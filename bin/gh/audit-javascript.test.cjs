const { test } = require("node:test")
const assert = require("node:assert/strict")
const { checkAudit } = require("./audit-javascript.cjs")

const summary = (counts = {}) => JSON.stringify({
  type: "auditSummary",
  data: { vulnerabilities: { info: 0, low: 0, moderate: 0, high: 0, critical: 0, ...counts } },
})

test("only HIGH/CRITICAL block across all Yarn severity combinations", () => {
  const severities = ["info", "low", "moderate", "high", "critical"]
  for (let mask = 0; mask < 32; mask++) {
    const counts = Object.fromEntries(severities.map((key, index) => [key, mask & (1 << index) ? 2 : 0]))
    const run = () => checkAudit(summary(counts), "", mask)
    if (mask & 24) assert.throws(run, /HIGH or CRITICAL/)
    else assert.deepEqual(run(), counts)
  }
})

test("registry errors fail even with a valid low-severity summary", () => {
  const error = JSON.stringify({ type: "error", data: "Registry unavailable" })
  assert.throws(() => checkAudit(`${error}\n${summary({ low: 1 })}`, "", 2), /audit error/)
  assert.throws(() => checkAudit(summary({ low: 1 }), error, 2), /audit error/)
})

test("missing, truncated, duplicate and invalid summaries fail closed", () => {
  for (const output of ["", "not json", '{"type":', `${summary()}\n${summary()}`,
    summary({ high: "0" }), summary({ moderate: -1 }), JSON.stringify({ type: "auditSummary" })]) {
    assert.throws(() => checkAudit(output, "", 0))
  }
})

test("unexpected exits and killed processes fail even when a summary was emitted", () => {
  for (const status of [1, 2, 127, null]) {
    assert.throws(() => checkAudit(summary(), "", status), /exit status/)
  }
})

test("ordinary Yarn warnings and Node diagnostics do not cause a false failure", () => {
  const warning = JSON.stringify({ type: "warning", data: "Resolution warning" })
  assert.equal(checkAudit(summary({ moderate: 4 }), `${warning}\n(node:1) DeprecationWarning\n`, 4).moderate, 4)
})
