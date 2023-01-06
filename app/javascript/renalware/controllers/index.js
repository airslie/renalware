import { application } from "./application"

import ToggleController from "./toggle_controller"
import ClinicsBmiCalculatorController from "./clinics/bmi_calculator_controller"
import WeightChangeCalculatorController from "./clinics/weight_change_calculator_controller"
import DietaryProteinCalculatorController from "./clinics/dietary_protein_calculator_controller"
import HDPrescriptionController from "./hd/prescription_administration_controller"
import MedicationsHomeDeliveryModalController from "./medications/home_delivery_modal_controller"
import SnippetsController from "./snippets_controller"
import LettersFormController from "./letters/form_controller"
import PrescriptionsController from "./medications/prescriptions_controller"
import ChartsController from "./charts_controller"
import SessionController from "./session_controller"
import SimpleToggleController from "./simple_toggle_controller"
import TabsController from "./tabs_controller"
import PDPetChartsController from "./pd/pet_charts_controller"
import PathologySparklinesController from "./pathology/sparklines_controller"
import CollapsibleController from "./collapsible_controller"
import DependentSelectController from "./dependent_select_controller"
import PatientAttachmentsController from "./patients/attachments_controller"
import SortableController from "./sortable_controller"
import SelectController from "./select_controller"
import RadioResetController from "./radio_reset_controller"
import ConditionalDisplayController from "./conditional_display_controller"
import SlimselectController from "./slimselect_controller"
import TurboModalController from "./turbo_modal_controller"
import FormController from "./form_controller"
import FlashController from "./flash_controller"
import FlatpickrController from "./flatpickr_controller"
import InputValueAlerterController from "./input_value_alerter_controller"
import SelectUpdateFrameController from "./select_update_frame_controller"

application.register("toggle", ToggleController)
application.register("hd-prescription-administration", HDPrescriptionController)
application.register(
  "home-delivery-modal",
  MedicationsHomeDeliveryModalController
)
application.register("snippets", SnippetsController)
application.register("letters-form", LettersFormController)
application.register("prescriptions", PrescriptionsController)
application.register("charts", ChartsController)
application.register("session", SessionController)
application.register("simple-toggle", SimpleToggleController)
application.register("tabs", TabsController)
application.register("pd-pet-chart", PDPetChartsController)
application.register("pathology-sparklines", PathologySparklinesController)
application.register("collapsible", CollapsibleController)
application.register("dependent-select", DependentSelectController)
application.register("patient-attachments", PatientAttachmentsController)
application.register("sortable", SortableController)
application.register("select", SelectController)
application.register("radio-reset", RadioResetController)
application.register("conditional-display", ConditionalDisplayController)
application.register("slimselect", SlimselectController)
application.register("turbo-modal", TurboModalController)
application.register("form", FormController)
application.register("flash", FlashController)
application.register("flatpickr", FlatpickrController)
application.register("input-value-alerter", InputValueAlerterController)
application.register("select-update-frame", SelectUpdateFrameController)
application.register("clinics--bmi-calculator", ClinicsBmiCalculatorController)
application.register(
  "clinics--weight-change-calculator",
  WeightChangeCalculatorController
)
application.register(
  "clinics--dietary-protein-calculator",
  DietaryProteinCalculatorController
)
