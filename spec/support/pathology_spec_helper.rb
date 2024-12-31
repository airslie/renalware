module PathologySpecHelper
  def create_descriptions(names)
    names.map { |name| create_observation_description(name) }
  end

  def create_observations(patient,
                          descriptions,
                          observed_at: Time.zone.now,
                          result: 1)
    descriptions.map do |description|
      request = create(
        :pathology_observation_request,
        patient: patient,
        requested_at: observed_at
      )

      create(:pathology_observation,
             request: request,
             description: description,
             observed_at: observed_at,
             result: result)
    end
  end

  # rubocop:disable Metrics/ParameterLists
  def create_request_with_observations(patient:,
                                       requestor_order_number: "123",
                                       filler_order_number: "F456",
                                       obr_code: "OBR1",
                                       obx_codes: ["OBX1"],
                                       requested_at: 1.year.ago,
                                       created_at: nil,
                                       count: 1,
                                       result: "1.1")
    request_desc = create(:pathology_request_description, code: obr_code)
    create(
      :pathology_observation_request,
      patient: patient,
      requestor_order_number: requestor_order_number,
      filler_order_number: filler_order_number,
      requested_at: requested_at,
      description: request_desc,
      created_at: created_at
    ).tap do |request|
      obx_codes.each do |obx_code|
        description = create(:pathology_observation_description, code: obx_code)
        (1..count).each do |num|
          create(
            :pathology_observation,
            request: request,
            description: description,
            observed_at: num.years.ago,
            result: result
          )
        end
      end
    end
  end
  # rubocop:enable Metrics/ParameterLists

  # name and code will be the same
  def create_observation_description(name)
    create(:pathology_observation_description, name: name, code: name)
  end

  def create_patient
    patient = create(:patient)
    Renalware::Pathology.cast_patient(patient)
  end

  def add_descriptions_not_observed_for_patient(*description_names)
    description_names.map { |name| create_observation_description(name) }
  end

  def filter_targeted_descriptions(descriptions)
    descriptions.select { |description| description.name.start_with?("target-") }
  end
end
