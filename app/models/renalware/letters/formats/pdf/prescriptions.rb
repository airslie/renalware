module Renalware
  module Letters
    module Formats
      module Pdf
        class Prescriptions
          include PresenterHelper
          include Prawn::View
          pattr_initialize :document, :letter, :x, :y, :width
          delegate :patient, to: :letter
          delegate :prescriptions, to: :patient
          BULLET = "• ".freeze

          def build
            bounding_box([x, y], width: width) do
              pad(4) { current_prescriptions }
              pad(4) { drugs_on_hd }
              pad(4) { recently_stopped_prescriptions }
            end
          end

          private

          def current_prescriptions
            title "Current Medications"
            recently_changed_ids = prescriptions.recently_changed.pluck(:id)
            present(prescriptions.current.ordered, presenter_class).each do |pres|
              # recently_changed.include?(prescription)
              row(pres, recently_changed: recently_changed_ids.include?(pres.id))
            end
          end

          def drugs_on_hd
            title "Drugs to give on Haemodialysis"
            present(prescriptions.current_hd.ordered, presenter_class).each { |pres| row(pres) }
          end

          def recently_stopped_prescriptions
            title "Recently Stopped Medications"
            present(prescriptions.recently_stopped.ordered, presenter_class).each do |pres|
              row(pres, date: pres.prescribed_on, recently_changed: true)
            end
          end

          def title(val)
            pad_bottom(5) { text(val, style: :bold) }
          end

          # TODO: Move to own view?
          def row(prescription, date: nil, recently_changed: false)
            # The entire prescription row is bold if it was recently changed
            styles = recently_changed ? [:bold] : []
            arr = [
              { text: BULLET, styles: [:bold] },
              { text: "#{prescription.drug.name} ", styles: styles },
              { text: "#{prescription.dose} ", styles: styles },
              { text: "#{prescription.medication_route.name} ", styles: styles },
              { text: "#{prescription.frequency} ", styles: styles },
              { text: prescription.provider_suffix, styles: [:bold] }
            ]
            arr << { text: " #{I18n.l(date)}" } if date.present?
            arr << { text: " *", styles: [:bold] } if recently_changed
            formatted_text(arr)
          end

          def presenter_class = Renalware::Medications::PrescriptionPresenter
        end
      end
    end
  end
end
