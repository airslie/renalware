export function debounce(fn, wait) {
  let timer = null

  return function (...args) {
    clearTimeout(timer)
    timer = setTimeout(() => {
      timer = null
      fn.apply(this, args)
    }, wait)
  }
}

export function throttleTrailing(fn, wait) {
  let timer = null
  let latestArgs = null
  let latestThis = null

  function throttled(...args) {
    latestArgs = args
    latestThis = this
    if (timer !== null) return

    timer = setTimeout(() => {
      timer = null
      fn.apply(latestThis, latestArgs)
    }, wait)
  }

  throttled.cancel = () => {
    clearTimeout(timer)
    timer = null
    latestArgs = null
    latestThis = null
  }

  return throttled
}
