// Inspired by stimulus-flatpickr
import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"
import { english } from "flatpickr/dist/l10n/default"

const dateConfig = {
  locale: {
    firstDayOfWeek: 1,
    months: {
      ...english.months,
      shorthand: [
        ...english.months.shorthand,
        // Allow users to input numbers in date field instead of Jan, Feb
        // Because we can't directly change `tokenRegex`, add the numbers to the
        // month shorthand locale, so they'll end up in the regexp string
        // See https://github.com/flatpickr/flatpickr/blob/614568f20daff9fdef906e8451876d8918c68d3c/src/index.ts#L2160
        // Alternative and cleaner approach would be to set our own `config.parseDate()` function
        // which has custom tokenRegex that fit our needs best.
        "01",
        "02",
        "03",
        "04",
        "05",
        "06",
        "07",
        "08",
        "09",
        "10",
        "11",
        "12",
      ],
    },
  },
  dateFormat: "d-M-Y",
  allowInput: true,
}

const timeConfig = {
  enableTime: true,
  noCalendar: true,
  dateFormat: "H:i",
}

export default class extends Controller {
  static values = {
    timeOnly: Boolean,
  }

  connect() {
    const config = this.timeOnlyValue ? timeConfig : dateConfig
    config["maxDate"] = this.element.dataset.flatpickrMaxDate
    config["minDate"] = this.element.dataset.flatpickrMinDate

    this.fp = flatpickr(this.element, config)
  }

  disconnect() {
    this.fp.destroy()
  }
}
