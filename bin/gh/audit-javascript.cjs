const fs = require("node:fs")
const { spawnSync } = require("node:child_process")

function checkAudit(stdout, stderr, status) {
  const events = stdout.split(/\r?\n/).filter(Boolean).map((line) => JSON.parse(line))
  const stderrEvents = stderr.split(/\r?\n/).flatMap((line) => {
    try { return [JSON.parse(line)] } catch { return [] }
  })
  if ([...events, ...stderrEvents].some((event) => event.type === "error")) {
    throw new Error("Yarn reported an audit error")
  }
  const summaries = events.filter((event) => event.type === "auditSummary")
  if (summaries.length !== 1) throw new Error("Expected one complete Yarn audit summary")
  const counts = summaries[0].data?.vulnerabilities
  const severities = ["info", "low", "moderate", "high", "critical"]
  if (!counts || severities.some((key) => !Number.isSafeInteger(counts[key]) || counts[key] < 0)) {
    throw new Error("Invalid Yarn audit vulnerability counts")
  }
  // Yarn Classic returns a severity bitmask, not a severity threshold.
  // Verify it against the summary so operational failures cannot become passes.
  const expectedStatus = severities.reduce((mask, key, index) => mask | (counts[key] > 0 ? 1 << index : 0), 0)
  if (status !== expectedStatus) throw new Error(`Unexpected Yarn audit exit status: ${status}`)
  if (counts.high || counts.critical) throw new Error("HIGH or CRITICAL vulnerabilities found")
  return counts
}

if (require.main === module) {
  try {
    const reportPath = process.argv[2]
    if (!reportPath) throw new Error("Usage: node audit-javascript.cjs REPORT_PATH")
    const result = spawnSync("yarn", ["audit", "--json"], {
      encoding: "utf8",
      maxBuffer: 32 * 1024 * 1024,
    })
    const stdout = result.stdout || ""
    const stderr = result.stderr || ""
    fs.writeFileSync(reportPath, stdout + stderr)
    process.stdout.write(stdout)
    process.stderr.write(stderr)
    if (result.error) throw result.error
    checkAudit(stdout, stderr, result.status)
    console.log("Audit passed: no HIGH/CRITICAL findings. All severities remain in the report.")
  } catch (error) {
    console.error(`Audit failed: ${error.message}`)
    process.exitCode = 1
  }
}

module.exports = { checkAudit }
