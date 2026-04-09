var Renalware = typeof Renalware === 'undefined' ? {} : Renalware;

Renalware.Problems = {
  Form: function(el, onProblemAddedCallback) {
    this.el = el,
    this.errorsContainer = this.el.find(".errors-container"),
    this.errorsList = this.errorsContainer.find("ul.error-messages"),
    this.callback = onProblemAddedCallback,

    this.init = function() {
      var self = this;
      this.el.on("submit", function(event) { self._onSubmit(event) });
    },

    this.reset = function() {
      this._clearForm();
      this._clearErrors();
    },

    this._clearForm = function() {
      this.el.trigger("reset");
      this.el.find(".hidden").val("");
    },

    this._clearErrors = function() {
      this.errorsList.html("");
      this.errorsContainer.hide();
    },

    this._addErrors = function(errors) {
      var list = this.errorsList;
      this.errorsContainer.show();
      $.each(errors, function(i) {
        list.append("<li>" + errors[i] + "</li>");
      });
    },

    // event handlers

    this._onSubmit = function(event) {
      event.preventDefault();

      var valuesToSubmit = this.el.serialize();
      var self = this;

      self._clearErrors();
      $.ajax({
        type: "POST",
        url: self.el.attr("action"), //submits it to the given url of the form
        data: valuesToSubmit,
        dataType: "JSON",
        statusCode: {
          201: function(problem) {
            self._onSuccess(problem);
          },
          406: function(jqXHR) {
            var errors = jqXHR.responseJSON;
            self._onErrors(errors);
          }
        }
      });
    },

    this._onSuccess = function(problem) {
      this.callback(problem);
    },

    this._onErrors = function(errors) {
      this._clearErrors();
      this._addErrors(errors);
    }
  },

  Modal: function(el, callback) {
    this.el = el,
    this.forms = [],
    this.callback = callback,

    this.init = function() {
      this._initForms();
    },

    this.open = function() {
      this.el.foundation("reveal", "open");
      this._resetForms();
    },

    this._initForms = function() {
      var self = this;
      this.forms = this.el.find("form").map(function() {
        var form = new Renalware.Problems.Form($(this), function(problem) {
          self._onProblemAdded(problem);
        });
        form.init();
        return(form);
      });
    },

    this._resetForms = function() {
      this.forms.each(function() {
        this.reset();
      })
    },

    // event handlers

    this._onSubmit = function(event) {
      event.preventDefault();

      var valuesToSubmit = this.form.serialize();
      var self = this;

      self._clearErrors();
      $.ajax({
        type: "POST",
        url: self.form.attr("action"), //submits it to the given url of the form
        data: valuesToSubmit,
        dataType: "JSON",
        statusCode: {
          201: function(problem) {
            self._onProblemAdded(problem);
          },
          406: function(jqXHR) {
            var errors = jqXHR.responseJSON;
            self._onErrors(errors);
          }
        }
      });
    },

    this._onProblemAdded = function(problem) {
      this.el.foundation('reveal', 'close');
      $('#current_problems tbody').append(problem.responseText);
      $('#js-snomed-id-field').val('');
      $('.js-snomed-id-hint').hide();
      this.callback(problem);
    }
  }
};

$(document).ready(function() {
  var trigger = $("a[data-behaviour='add-new-problem']");

  if (trigger.length > 0) {
    var modal = new Renalware.Problems.Modal($("#add-patient-problem-modal"), function(problem) {
      $.getScript(document.URL);
    });
    modal.init();

    trigger.on("click", function(event) {
       event.preventDefault();
       modal.open();
       $('#js-snomed-id-field').val('');
       $('.js-snomed-id-hint').hide();
    })
  }
});
