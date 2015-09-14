require 'rails_helper'

module Renalware
  describe DoctorsHelper, type: :helper do
    include RSpecHtmlMatchers

    describe 'practices_options_for_select' do
      it 'returns Practices as html options' do
        p1 = create(:practice, name: 'AAA')
        p2 = create(:practice, name: 'BBB')
        p3 = create(:practice, name: 'CCC')
        doctor = build_stubbed(:doctor, practices: [p1,p3])
        actual = practices_options_for_select(doctor)

        expect(actual).to have_tag('option', with: { selected: 'selected' }) { with_text('AAA') }
        expect(actual).to have_tag('option') { with_text('BBB') }
        expect(actual).to have_tag('option', with: { selected: 'selected' }) { with_text('CCC') }
      end
    end

    describe 'practices_or_address' do
      it 'formats the alternative Address' do
        address = build_stubbed(:address)
        doctor = build_stubbed(:doctor, address: address)
        actual = practices_or_address(doctor)

        expect(actual).to match("#{address.street_1}, #{address.postcode}")
      end

      it 'formats the practice names when present' do
        practice = create(:practice, name: 'Legoland Health Centre')
        doctor = build_stubbed(:doctor, practices: [practice])
        actual = practices_or_address(doctor)

        expect(actual).to match('Legoland Health Centre')
      end
    end
  end
end