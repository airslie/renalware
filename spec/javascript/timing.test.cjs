const test = require("node:test")
const assert = require("node:assert/strict")

const load = () => import("../../app/javascript/renalware/helpers/timing.js")

function withFakeTimers(run) {
  return async (t) => {
    t.mock.timers.enable({ apis: ["setTimeout"] })
    await run(t)
  }
}

test("debounce calls the function once, after the wait, with the last arguments", withFakeTimers(async (t) => {
  const { debounce } = await load()
  const calls = []
  const debounced = debounce((value) => calls.push(value), 300)

  debounced("a")
  debounced("b")
  t.mock.timers.tick(299)
  assert.deepEqual(calls, [])
  t.mock.timers.tick(1)

  assert.deepEqual(calls, ["b"])
}))

test("debounce restarts the wait on every call", withFakeTimers(async (t) => {
  const { debounce } = await load()
  let count = 0
  const debounced = debounce(() => count++, 300)

  debounced()
  t.mock.timers.tick(200)
  debounced()
  t.mock.timers.tick(200)
  assert.equal(count, 0)
  t.mock.timers.tick(100)

  assert.equal(count, 1)
}))

test("debounce preserves this", withFakeTimers(async (t) => {
  const { debounce } = await load()
  const target = { name: "form", seen: null, run: debounce(function () { target.seen = this.name }, 10) }

  target.run()
  t.mock.timers.tick(10)

  assert.equal(target.seen, "form")
}))

test("throttleTrailing does not call the function immediately", withFakeTimers(async (t) => {
  const { throttleTrailing } = await load()
  let count = 0
  const throttled = throttleTrailing(() => count++, 1000)

  throttled()

  assert.equal(count, 0)
}))

test("throttleTrailing calls once at the end of the period with the last arguments", withFakeTimers(async (t) => {
  const { throttleTrailing } = await load()
  const calls = []
  const throttled = throttleTrailing((value) => calls.push(value), 1000)

  throttled("a")
  t.mock.timers.tick(400)
  throttled("b")
  t.mock.timers.tick(599)
  assert.deepEqual(calls, [])
  t.mock.timers.tick(1)

  assert.deepEqual(calls, ["b"])
}))

test("throttleTrailing keeps firing every period under constant activity", withFakeTimers(async (t) => {
  const { throttleTrailing } = await load()
  let count = 0
  const throttled = throttleTrailing(() => count++, 1000)

  for (let elapsed = 0; elapsed < 3000; elapsed += 100) {
    throttled()
    t.mock.timers.tick(100)
  }

  assert.equal(count, 3)
}))

test("throttleTrailing starts a new period for a call after the previous one fired", withFakeTimers(async (t) => {
  const { throttleTrailing } = await load()
  let count = 0
  const throttled = throttleTrailing(() => count++, 1000)

  throttled()
  t.mock.timers.tick(1000)
  throttled()
  t.mock.timers.tick(1000)

  assert.equal(count, 2)
}))

test("throttleTrailing cancel prevents the pending call", withFakeTimers(async (t) => {
  const { throttleTrailing } = await load()
  let count = 0
  const throttled = throttleTrailing(() => count++, 1000)

  throttled()
  t.mock.timers.tick(500)
  throttled.cancel()
  t.mock.timers.tick(1000)

  assert.equal(count, 0)
}))

test("throttleTrailing can be scheduled again after cancel", withFakeTimers(async (t) => {
  const { throttleTrailing } = await load()
  const calls = []
  const throttled = throttleTrailing((value) => calls.push(value), 1000)

  throttled("cancelled")
  throttled.cancel()
  throttled("kept")
  t.mock.timers.tick(1000)

  assert.deepEqual(calls, ["kept"])
}))

test("throttleTrailing cancel is harmless when nothing is pending", withFakeTimers(async (t) => {
  const { throttleTrailing } = await load()
  let count = 0
  const throttled = throttleTrailing(() => count++, 1000)

  throttled.cancel()
  throttled()
  t.mock.timers.tick(1000)
  throttled.cancel()

  assert.equal(count, 1)
}))
