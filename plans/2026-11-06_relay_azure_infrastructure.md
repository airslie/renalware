# Relay: proposed Azure infrastructure

Status: proposal for discussion. Cost figures are order-of-magnitude estimates for planning, **not
quotes**: check them in the Azure pricing calculator (UK South) before committing. Where I am not
certain of a current Azure limit I say so; verify those.

Related: `2026-11-06_relay_gp_connect_architecture.md` (what Relay is and how it behaves).

## 1. What the workload actually is

| Task | Shape | Implication |
|---|---|---|
| Web UI (department admins, Entra login) | A few to tens of concurrent users, mostly reading | Small, steady. Needs HA but not scale |
| Web API (submit letters, get status) | Bursty: hospital systems posting letters, mostly office hours | Small. PDFs up to a few MB per request |
| Inbound HL7 via Mirth | Message-driven, must not lose messages | Mirth is a stateful single instance; the sender retries until it gets an ACK |
| GP Connect delivery | Background: send, then poll MESH for responses (up to ~20 days) | Needs an always-on worker. MESH polling must be one-at-a-time per mailbox |

Volume is modest (letters, not telemetry), so this is a **reliability and security** problem, not
a performance one. Spend on redundancy of the data and on isolation; do not over-provision compute.

Relay is also naturally **asynchronous**. A short outage delays delivery but does not lose
letters, because each sender can print (or retry) on failure, and the Renalware side has an outbox
and fail-safe timeout. That justifies in-region redundancy without a hot second region.

## 2. Recommended shape

```
 Hospital / Renalware                         Azure (UK South, one VNet)
 ----------------------                       ------------------------------------------------
 HOSPA interface engine --HL7 (MLLP/HTTPS)--> [Container Apps env, internal]
                                                 Mirth (1 replica)  --REST--> Relay API
 Renalware (REST client) ---HTTPS------------> [App Service plan, 2 instances, zone-redundant*]
 Department admins ---HTTPS (Entra login)----->   Relay web + API  (Rails, Puma)
                                                 |
                                               [Container Apps env]
                                                 Relay worker (GoodJob, mesh queue = 1 poller/mailbox)
                                                 |  \
                                  private endpoints   \--outbound via NAT Gateway (static IP)--> MESH
                                   |        |        |
                      PostgreSQL Flexible   Blob      Key Vault
                      (zone-redundant HA)   Storage   (MESH certs, secrets)
                                   Log Analytics + Application Insights, alerts
```
\* verify the current minimum instance count for zone-redundant App Service plans.

### Components and why

| Component | Choice | Reason |
|---|---|---|
| Region | UK South primary, UK West for backup restore | Data residency; paired region |
| Web + API | **App Service (Linux container), 2 instances** | Same as Renalware, so existing skills, runbooks and the entrypoint work. Deployment slots allow a safe swap |
| Worker | **Container Apps**, **min 1 replica**, max 2 | GoodJob cron/polling needs an always-on process, so do **not** scale to zero |
| Mirth | **Container Apps**, exactly 1 replica, internal ingress | Open-source Mirth is not clustered. Restart on failure; the sender retries until ACK (see 3.3) |
| Queue/jobs | **GoodJob on Postgres** (no Service Bus, no Redis) | Already used. Transactional with the outbox/deliveries; one fewer thing to run, pay for and secure |
| Database | **Azure Database for PostgreSQL Flexible Server**, zone-redundant HA, private access | The system of record. Point-in-time restore (set 35 days) and geo-redundant backup |
| Documents (PDFs) | **Blob Storage** (private endpoint, immutable/lifecycle rules) | Keep PDFs and raw payloads out of Postgres; cheap, encrypted, retention-managed (see 3.5) |
| Secrets | **Key Vault** (RBAC, private endpoint) | MESH client cert/key, mailbox passwords, API secrets. Apps read with managed identity |
| Egress | **NAT Gateway** on the worker subnet | One stable outbound IP for MESH (and for allow-listing if ever needed) |
| Images | **Azure Container Registry** (Basic/Standard) | Managed-identity pull; one image for web and worker (different command) |
| Observability | **Log Analytics + Application Insights** (OpenTelemetry is already in the Gemfile) | Alerts below |

One Rails image, two roles: `web` (Puma) and `worker` (GoodJob external). Mirth is a second image.

Alternative for web/API: run it in Container Apps too (one platform, a little cheaper, no App
Service plan). I recommend App Service only to match existing operations. If the team would
rather run one platform for Relay, that is a reasonable simplification.

## 3. Points that need deliberate design

### 3.1 One MESH poller per mailbox
Downloading and acknowledging a MESH message removes it from the inbox, so two pollers on one
mailbox steal each other's responses. With more than one worker replica this must be enforced in
code, not by hoping: use GoodJob concurrency control keyed on the mailbox id for handshake,
check-inbox and download/acknowledge. Mailbox-per-department then scales naturally (one key each).

### 3.2 Postgres connection pooling
GoodJob needs session-level advisory locks and `LISTEN/NOTIFY`. The built-in PgBouncer on Flexible
Server in **transaction** mode breaks both. Connect the worker directly (or use session pooling).
The web tier can use pooling if connections become a problem.

### 3.3 Not losing HL7 messages
Mirth must ACK the sender only **after** Relay has durably stored the submission (API returns 2xx;
submissions are idempotent on the source message id). Then a Relay or Mirth outage just makes the
sender's interface queue back up and retry. Mirth's own message store sits in a separate database
(or schema) on the same Postgres server, with channel configuration kept in git.
Check the current licensing/support position of Mirth before committing to it for production.

### 3.4 Network exposure
- Postgres, Key Vault, Storage: **private endpoints only**, no public access.
- Mirth admin: never public. MLLP only reachable from the hospital.
- Relay API: restrict by IP access rules to the hospital's egress ranges (Renalware/HOSPA) plus
  client-credential auth; rate-limit in the app.
- Relay UI: HTTPS only, TLS 1.2+, Entra login, Conditional Access enforced by the tenant. If staff
  reach it from the internet, add Azure Front Door with WAF (see cost), otherwise IP-restrict to
  the hospital network and skip it.
- HL7 transport is the open question. Either HOSPA's interface engine **pushes HTTPS** to Relay
  (simplest, nothing special), or HL7 arrives as **MLLP over a site-to-site VPN/ExpressRoute**.
  MLLP across the open internet is not acceptable without TLS. The VPN option adds a gateway cost.

### 3.5 Data protection
Relay holds other departments' letters. Use Blob for PDFs with lifecycle deletion after the agreed
retention; store only metadata long-term. Keep PHI out of logs (log ids, not names/NHS numbers),
turn on Defender for Cloud, enforce UK-only regions with Azure Policy, and keep audit logs of
document views. Customer-managed keys are available if the hospital requires them.

### 3.6 MESH certificates
Store the client certificate and key in Key Vault and mount or inject them into the worker. Alert
well before expiry. (The RSA-key-via-env-var bug in the old code was fixed in the gem, so
either PEM form works as config contents.)

## 4. Redundancy and recovery

| Failure | Behaviour |
|---|---|
| App Service instance or zone | Other instance serves; zone-redundant plan survives a zone loss |
| Worker replica crash | Container Apps restarts it; GoodJob re-runs unfinished jobs; MESH steps are idempotent per operation |
| Mirth crash | Restart; sender retries unacknowledged HL7 |
| Postgres zone/server failure | Zone-redundant HA fails over automatically |
| Region loss | **Restore from geo-redundant backup into UK West**: RPO roughly an hour or more, RTO hours. Deliberately not active-active (cost); letters fall back to printing |
| Bad deploy | Slot swap back; migrations written backwards-compatible |

Test a restore and a failover before go-live. An untested backup is not a backup.

## 5. Environments

- **dev**: smallest everything, Burstable Postgres, one instance each, scale down out of hours.
- **staging/UAT**: production shape at the smallest size; talks to the **MESH integration**
  environment and HOSPA's test interface. Needed for NHS assurance anyway.
- **prod**: as above. Separate resource groups (ideally subscriptions), same Bicep/Terraform module
  with a size parameter, deployed from GitHub Actions with OIDC (no stored secrets).

## 6. Alerts that matter (patient-safety, not just uptime)
MESH handshake failing or a poller not running; deliveries pending beyond N hours; failed
deliveries by sender; worker queue depth/age; HL7 inbound stopped; MESH cert or Key Vault secret
nearing expiry; Postgres storage/CPU/replication; failed logins spike. Route to a monitored channel
out of hours, because silent failure here means letters nobody realises were not delivered.

## 7. Indicative monthly cost (UK South, pay-as-you-go, very rough)

| Item | Lean prod | Resilient prod |
|---|---|---|
| App Service plan (2 x P1v3-class) | ~£200 | ~£200 (zone-redundant needs verifying) |
| Container Apps (worker + Mirth) | ~£70–100 | ~£100–150 |
| PostgreSQL Flexible Server | ~£80 (single zone) | ~£300–400 (zone-redundant HA, General Purpose) |
| Blob, Key Vault, ACR | ~£15 | ~£25 |
| NAT Gateway | ~£35 | ~£35 |
| Log Analytics / App Insights | ~£30–60 | ~£60–120 |
| Front Door + WAF (only if internet-facing UI) | not included | ~£30 Standard, much more with WAF Premium |
| VPN gateway (only if MLLP over VPN) | not included | ~£100+ |
| **Rough total** | **~£450–550** | **~£850–1,200** |

Non-prod adds roughly 30–40% of one prod. Levers: Reserved Instances (1 or 3 year) on App Service
and Postgres commonly save a third or more once sizing is stable; Burstable and out-of-hours
shutdown for non-prod; log sampling and retention limits.

## 8. Recommendation
Start with the **resilient** shape for the database (zone-redundant HA, private endpoints, Blob,
Key Vault, NAT) because that is where loss would hurt, and the **lean** shape for compute (2
small web instances, one worker, one Mirth). Defer Front Door/WAF and any VPN until the HL7
transport and the UI exposure decisions are made. Revisit sizing after a month of real traffic.

## 9. Questions that change the design
1. How will HL7 reach Relay: HOSPA pushes HTTPS, or MLLP over VPN/ExpressRoute? (VPN gateway cost, Mirth ingress.)
2. Will department admins use the UI from the hospital network only, or from the internet? (Front Door/WAF.)
3. Required RPO/RTO and retention for PDFs and payloads? (backup tier, lifecycle rules.)
4. One Azure subscription per customer hospital (single-tenant instances, as decided for Entra), or a shared one? Per-hospital instances multiply the fixed costs above, so the Bicep module should be parameterised from day one.
5. Hospital or NHS hosting requirements (DSPT, private connectivity, CMK)?
6. Is Mirth definitely wanted inside Relay, or can the hospital's interface engine call the API directly? Dropping it removes the Mirth Container App and its database.

## 10. Decisions after review (2026-11-06)

1. **HL7 into Relay:** HOSPA sends MLLP to Mirth. Mirth posts to the Relay **web API** (not the
   database): parsed fields plus the raw HL7 with the PDF removed, idempotent on MSH-10; ACK the
   sender only after a 2xx. Details in `2026-11-06_relay_gp_connect_architecture.md` section 5.2a.
2. **Network:** the UI, API and every Azure service are reachable from the hospital network only.
   Private endpoints for the App Service, Postgres, Key Vault and Storage; no public ingress;
   **Front Door/WAF dropped**. The hospital must reach the VNet (existing link or VPN); Renalware
   and Mirth reach Relay by VNet peering. Outbound to Entra and MESH goes through the NAT Gateway.
3. **Mirth:** reuse the existing Renalware Mirth for now (no new Container App or Mirth database).
   Separate channels, message-size and heap limits, and no retention of message content after
   delivery. Keep channels thin and exported to git because of the planned move to an open-source
   fork. Revisit a dedicated instance if Relay's volume threatens Renalware's feeds.
4. **Hosting model (decided):** one Relay instance per hospital, in **that hospital's own Azure
   subscription**, beside its Renalware (as Renalware already is). Share the VNet, Mirth, NAT
   Gateway and Log Analytics; Relay's incremental cost is therefore below the standalone figures in
   section 7. Relay web may share Renalware's App Service plan if there is headroom (a plan is the
   billing unit) but use a **separate Postgres server** (isolation, separate data purpose, no
   noisy neighbour). The Bicep/Terraform module takes parameters to reuse an existing VNet, Mirth,
   NAT and Log Analytics or create them. The Entra tenant is the hospital's own (matches the
   single-tenant decision); Airslie staff are guests with delegated access (Azure Lighthouse or
   similar), and images are deployed into each hospital's subscription using whatever Renalware's
   release pipeline already does. Check UK West quota in each subscription for the DR plan.
5. **Recovery targets:** RTO 24 hours, RPO 2 hours. This allows **non-HA Postgres** with
   point-in-time restore and geo-redundant backup (about GBP 200-300 per month cheaper than
   zone-redundant HA); the "lean" column in section 7 now meets the targets. Needs a rehearsed
   restore into UK West, infrastructure code able to target the DR region, and confirmation that
   HOSPA can resend HL7 for at least the last few hours (Mirth acknowledgements inside the RPO
   window would otherwise be lost). Verify the current geo-restore recovery point in Azure docs.

## 11. HL7 recovery (TIE -> Mirth -> Relay)

Principle: **at-least-once delivery from the TIE, idempotent Relay** (sender + MSH-10). Mirth
ACKs only after Relay returns 2xx, so the TIE's own queue and retry covers Relay, Mirth and link
outages. A restore followed by a replay is safe.

| Failure | Result | Recovers? |
|---|---|---|
| Relay API down / 5xx | Mirth does not ACK; TIE resends | Yes, if the TIE retries and queues (ask how long, how deep) |
| Mirth down or restarting | MLLP connection refused; TIE queues | Yes, same dependency |
| Hospital-to-Azure link down | As above | Yes |
| Relay rejects (4xx, e.g. bad NHS number) | Mirth NACKs | **No**: HOSPA must correct and resend |
| Poison message stalls the channel | Queue stops behind it | Only with an alert |
| Relay database restored to an earlier point | Messages ACKed after the restore point are gone | Only by replay |

Consequences for the design:
- **Does a NACK block the interface?** If the TIE stops the queue behind a rejected message, one
  bad letter delays every department's letters. In that case store rejects in Relay as `rejected`
  (visible to the department) and ACK, instead of NACKing.
- **Relay can only show what it received.** Add a per-sender "nothing received in N hours" alert,
  and alert on TIE error counts. A letter that never arrives is otherwise invisible to a
  department admin, who is responsible for printing undelivered letters.
- **Replay after a restore** can send a letter to the GP twice (sent after the restore point,
  then replayed). A duplicate is better than a lost letter; document it. MESH responses for
  messages Relay no longer knows appear as unreconciled, which flags the case.
- If HOSPA can replay a day or more, the 2-hour RPO matters mainly for delivery **status**, not
  for letters arriving over HL7. Renalware's outbox is idempotent on letter uuid and can resubmit
  anything still pending.

To ask HOSPA's integration team: (1) does the TIE retry on NACK/no-ACK, for how long, and how many
messages can it queue? (2) does a NACK block the messages behind it? (3) can it replay by time
window or message id, and how long does it keep sent messages?
