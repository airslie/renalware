const fs = require("node:fs")
const path = require("node:path")

const SNAPSHOT_PATH = path.join(".github", "dependency_owners.json")
const NPM_MANIFESTS = ["package.json", path.join("documentation", "package.json")]
const CONCURRENCY = 8
const ATTEMPTS = 4

const sorted = (values) => [...values].sort()

function parseLockfileDependencies(lockfile) {
  const lines = lockfile.split(/\r?\n/)
  const start = lines.indexOf("DEPENDENCIES")
  if (start === -1) throw new Error("No DEPENDENCIES section in Gemfile.lock")
  const names = []
  for (const line of lines.slice(start + 1)) {
    if (!line.startsWith("  ")) break
    const match = line.match(/^ {2}(\S+?)(!)?(?: \(.*\))?$/)
    if (match && !match[2]) names.push(match[1])
  }
  return sorted(new Set(names))
}

function parseNpmDependencies(manifests) {
  const names = manifests.flatMap((manifest) => [
    ...Object.keys(manifest.dependencies || {}),
    ...Object.keys(manifest.devDependencies || {}),
  ])
  return sorted(new Set(names))
}

function compareSnapshots(snapshot, current) {
  const result = { changes: [], unrecorded: [], stale: [] }
  for (const ecosystem of ["rubygems", "npm"]) {
    const recorded = snapshot[ecosystem] || {}
    const live = current[ecosystem] || {}
    for (const name of Object.keys(live)) {
      if (!(name in recorded)) {
        result.unrecorded.push({ ecosystem, name })
        continue
      }
      const added = live[name].filter((owner) => !recorded[name].includes(owner))
      const removed = recorded[name].filter((owner) => !live[name].includes(owner))
      if (added.length || removed.length) {
        result.changes.push({ ecosystem, name, added: sorted(added), removed: sorted(removed) })
      }
    }
    for (const name of Object.keys(recorded)) {
      if (!(name in live)) result.stale.push({ ecosystem, name })
    }
  }
  return result
}

async function fetchJson(url) {
  let lastError
  for (let attempt = 1; attempt <= ATTEMPTS; attempt++) {
    try {
      const response = await fetch(url, { headers: { accept: "application/json" } })
      if (response.ok) return await response.json()
      lastError = new Error(`${url} responded ${response.status}`)
      if (response.status === 404) break
    } catch (error) {
      lastError = error
    }
    await new Promise((resolve) => setTimeout(resolve, attempt * 1000))
  }
  throw lastError
}

async function gemOwners(name) {
  const owners = await fetchJson(`https://rubygems.org/api/v1/gems/${encodeURIComponent(name)}/owners.json`)
  return sorted(owners.map((owner) => owner.handle || `id:${owner.id}`))
}

async function npmOwners(name) {
  const latest = await fetchJson(`https://registry.npmjs.org/${name.replace("/", "%2F")}/latest`)
  return sorted((latest.maintainers || []).map((maintainer) => maintainer.name))
}

async function mapWithConcurrency(names, lookup) {
  const results = {}
  const queue = [...names]
  const workers = Array.from({ length: CONCURRENCY }, async () => {
    while (queue.length) {
      const name = queue.shift()
      results[name] = await lookup(name)
    }
  })
  await Promise.all(workers)
  return Object.fromEntries(Object.keys(results).sort().map((name) => [name, results[name]]))
}

async function collectCurrentOwners() {
  const gems = parseLockfileDependencies(fs.readFileSync("Gemfile.lock", "utf8"))
  const manifests = NPM_MANIFESTS.filter((file) => fs.existsSync(file))
    .map((file) => JSON.parse(fs.readFileSync(file, "utf8")))
  const packages = parseNpmDependencies(manifests)
  return {
    rubygems: await mapWithConcurrency(gems, gemOwners),
    npm: await mapWithConcurrency(packages, npmOwners),
  }
}

function describe({ ecosystem, name }) {
  return `${ecosystem}/${name}`
}

function report(result) {
  const lines = []
  for (const change of result.changes) {
    const parts = []
    if (change.added.length) parts.push(`added: ${change.added.join(", ")}`)
    if (change.removed.length) parts.push(`removed: ${change.removed.join(", ")}`)
    lines.push(`OWNER CHANGE  ${describe(change)}  ${parts.join("; ")}`)
  }
  for (const entry of result.unrecorded) lines.push(`NOT RECORDED  ${describe(entry)}`)
  for (const entry of result.stale) lines.push(`STALE ENTRY   ${describe(entry)} (no longer a direct dependency)`)
  return lines
}

async function main() {
  const update = process.argv.includes("--update")
  const current = await collectCurrentOwners()
  if (update) {
    fs.writeFileSync(SNAPSHOT_PATH, `${JSON.stringify(current, null, 2)}\n`)
    console.log(`Wrote ${SNAPSHOT_PATH}`)
    return
  }
  const snapshot = JSON.parse(fs.readFileSync(SNAPSHOT_PATH, "utf8"))
  const result = compareSnapshots(snapshot, current)
  const lines = report(result)
  if (lines.length) console.log(lines.join("\n"))
  if (result.changes.length || result.unrecorded.length) {
    console.error(
      "\nReview the owner changes above. If they are legitimate, run " +
      "`node bin/gh/check-dependency-owners.cjs --update` and commit the snapshot.",
    )
    process.exitCode = 1
    return
  }
  if (result.stale.length) {
    console.log("\nStale entries do not fail the check; run with --update to prune them.")
  }
  console.log("Dependency owners match the recorded snapshot.")
}

if (require.main === module) {
  main().catch((error) => {
    console.error(error.message)
    process.exitCode = 1
  })
}

module.exports = { parseLockfileDependencies, parseNpmDependencies, compareSnapshots }
