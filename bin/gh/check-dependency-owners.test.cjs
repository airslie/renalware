const test = require("node:test")
const assert = require("node:assert/strict")
const {
  parseLockfileDependencies,
  parseNpmDependencies,
  compareSnapshots,
} = require("./check-dependency-owners.cjs")

const lockfile = `GIT
  remote: https://github.com/airslie/fhir_stu3_models.git
  revision: abc
  specs:
    fhir_stu3_models (3.1.1)

GEM
  remote: https://rubygems.org/
  specs:
    rails (8.1.2)
      activesupport (= 8.1.2)

PLATFORMS
  ruby

DEPENDENCIES
  debug (>= 1.0.0)
  fhir_stu3_models!
  pagy (~> 43)
  rails (~> 8.1.2)
  wkhtmltopdf-binary (= 0.12.6.8)

RUBY VERSION
   ruby 4.0.0

BUNDLED WITH
   4.0.0
`

test("parseLockfileDependencies lists direct gems and skips git sourced ones", () => {
  assert.deepEqual(
    parseLockfileDependencies(lockfile),
    ["debug", "pagy", "rails", "wkhtmltopdf-binary"],
  )
})

test("parseNpmDependencies merges dependencies and devDependencies sorted and unique", () => {
  const manifests = [
    { dependencies: { rollup: "^4", "@hotwired/stimulus": "^3" }, devDependencies: { eslint: "^10" } },
    { dependencies: { rollup: "^4" } },
  ]
  assert.deepEqual(parseNpmDependencies(manifests), ["@hotwired/stimulus", "eslint", "rollup"])
})

test("compareSnapshots reports no problems when owners are unchanged", () => {
  const snapshot = { rubygems: { rails: ["dhh", "tenderlove"] }, npm: { rollup: ["lukastaegert"] } }
  const current = { rubygems: { rails: ["tenderlove", "dhh"] }, npm: { rollup: ["lukastaegert"] } }
  assert.deepEqual(compareSnapshots(snapshot, current), { changes: [], unrecorded: [], stale: [] })
})

test("compareSnapshots reports added and removed owners", () => {
  const snapshot = { rubygems: { devise: ["alice", "bob"] }, npm: {} }
  const current = { rubygems: { devise: ["alice", "mallory"] }, npm: {} }
  assert.deepEqual(compareSnapshots(snapshot, current).changes, [
    { ecosystem: "rubygems", name: "devise", added: ["mallory"], removed: ["bob"] },
  ])
})

test("compareSnapshots reports packages missing from the snapshot as unrecorded", () => {
  const snapshot = { rubygems: {}, npm: {} }
  const current = { rubygems: { pagy: ["ddnexus"] }, npm: { moment: ["ichernev"] } }
  assert.deepEqual(compareSnapshots(snapshot, current).unrecorded, [
    { ecosystem: "rubygems", name: "pagy" },
    { ecosystem: "npm", name: "moment" },
  ])
})

test("compareSnapshots reports snapshot entries no longer in the manifests as stale", () => {
  const snapshot = { rubygems: { virtus: ["solnic"] }, npm: {} }
  const current = { rubygems: {}, npm: {} }
  assert.deepEqual(compareSnapshots(snapshot, current).stale, [
    { ecosystem: "rubygems", name: "virtus" },
  ])
})
