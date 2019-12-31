# frozen_string_literal: true

xml = builder

xml.SendingFacility Renalware.config.ukrdc_sending_facility_name,
                    channelName: "Renalware",
                    time: Time.zone.now.to_datetime.change(sec: 0)

xml.SendingExtract "UKRDC"
