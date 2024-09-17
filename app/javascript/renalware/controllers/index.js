import { application } from "./application"
import Dropdown from "stimulus-dropdown"

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
import ShowOnSelectedController from "./show_on_selected_controller"
import TabsController from "./tabs_controller"
import PDPetChartsController from "./pd/pet_charts_controller"
import PathologySparklinesController from "./pathology/sparklines_controller"
import CollapsibleController from "./collapsible_controller"
import DependentSelectController from "./dependent_select_controller"
import PatientAttachmentsController from "./patients/attachments_controller"
import PatientSearchController from "./patients/search_controller"
import SortableController from "./sortable_controller"
import SelectController from "./select_controller"
import RadioResetController from "./radio_reset_controller"
import SelectResetController from "./select_reset_controller"
import ConditionalDisplayController from "./conditional_display_controller"
import SlimselectController from "./slimselect_controller"
import SlimselectAjaxController from "./slimselect_ajax_controller"
import ModalController from "./modal_controller"
import FormController from "./form_controller"
import AlternativeFormSubmitterController from "./alternative_form_submitter_controller"
import FlashController from "./flash_controller"
import FlatpickrController from "./flatpickr_controller"
import InputValueAlerterController from "./input_value_alerter_controller"
import SelectUpdateFrameController from "./select_update_frame_controller"
import AddTopHorizontalScrollbarController from "./add_top_horizontal_scrollbar_controller"
import PreviewController from "./preview_controller"
import ReadMoreController from "./read_more_controller"
import GridRowAutoSpanController from "./grid_row_auto_span_controller"
import TableColumnHoverController from "./table_column_hover_controller"
import NavbarController from "./navbar_controller"
import TabbedNavigationController from "./tabbed_navigation_controller"
import TurboModalController from "./turbo_modal_controller"
import ChartsRawController from "./charts_raw_controller"
import PopoverController from "./popover_controller"
import LettersBatchCompileController from "./letters/batch_compile_controller"

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
application.register("show-on-selected", ShowOnSelectedController)
application.register("tabs", TabsController)
application.register("pd-pet-chart", PDPetChartsController)
application.register("pathology-sparklines", PathologySparklinesController)
application.register("collapsible", CollapsibleController)
application.register("dependent-select", DependentSelectController)
application.register("patient-attachments", PatientAttachmentsController)
application.register("patient-search", PatientSearchController)
application.register("sortable", SortableController)
application.register("select", SelectController)
application.register("radio-reset", RadioResetController)
application.register("select-reset", SelectResetController)
application.register("conditional-display", ConditionalDisplayController)
application.register("slimselect", SlimselectController)
application.register("slimselect-ajax", SlimselectAjaxController)
application.register("modal", ModalController)
application.register("form", FormController)
application.register(
  "alternative-form-submitter",
  AlternativeFormSubmitterController
)
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
application.register(
  "add-top-horizontal-scrollbar",
  AddTopHorizontalScrollbarController
)
application.register("preview", PreviewController)
application.register("read-more", ReadMoreController)
application.register("grid-row-auto-span", GridRowAutoSpanController)
application.register("table_column_hover", TableColumnHoverController)
application.register("navbar", NavbarController)
application.register("dropdown", Dropdown) // https://www.stimulus-components.com/docs/stimulus-dropdown/
application.register("tabbed-navigation", TabbedNavigationController)
application.register("turbo-modal", TurboModalController)
application.register("charts-raw", ChartsRawController)
application.register("popover", PopoverController)
application.register("letters-batch-compile", LettersBatchCompileController)
