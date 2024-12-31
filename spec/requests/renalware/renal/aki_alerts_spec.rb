describe "AKI alert management" do
  let(:user) { @current_user }
  let(:hospital_ward) { create(:hospital_ward) }
  let(:default_action) { create(:aki_alert_action, name: SecureRandom.uuid) }

  def aki_alert(at:, hotlist: false, action: nil)
    create(
      :aki_alert,
      notes: SecureRandom.uuid,
      patient: create(:renal_patient, by: user),
      hospital_ward: hospital_ward,
      max_aki: 2,
      aki_date: at,
      action: action || default_action,
      by: user,
      created_at: at,
      hotlist: hotlist
    )
  end

  describe "GET index" do
    describe "with no filters and date_range 'all'" do
      it "renders a list of AKI Alerts" do
        a1 = aki_alert(at: Time.zone.now)
        a2 = aki_alert(at: 1.day.ago)
        a3 = aki_alert(at: 1.day.from_now)

        get renal_aki_alerts_path(
          q: {
            date_range: Renalware::Renal::AKIAlertSearchForm::DATE_RANGE_ALL
          }
        )

        expect(response).to be_successful
        expect(response.body).to match(a1.notes)
        expect(response.body).to match(l(Time.zone.today))

        expect(response.body).to match(a2.notes)
        expect(response.body).to match(l(Time.zone.today - 1.day))

        expect(response.body).to match(a3.notes)
        expect(response.body).to match(l(Time.zone.today + 1.day))

        expect(response.body).to match(hospital_ward.name)
      end
    end

    describe "filtering by created_at_within_configured_today_period" do
      it "renders a list of AKI Alerts created in the 24 hours preceding 09:45 today" do
        # Using travel_to here as this test failed n the first day after clocks fell back!
        travel_to(Date.parse("2023-10-01 05:00:01")) do
          today = Time.zone.today
          # too early yesterday
          a1 = aki_alert(
            at: today - 1.day + Time.zone.parse("09:43").seconds_since_midnight.seconds
          )
          # just in time to make it in today
          a2 = aki_alert(at: today + Time.zone.parse("09:44").seconds_since_midnight.seconds)
          # too late today
          a3 = aki_alert(at: today + Time.zone.parse("09:46").seconds_since_midnight.seconds)

          get renal_aki_alerts_path(
            q: {
              date_range: Renalware::Renal::AKIAlertSearchForm::DATE_RANGE_TODAY
            }
          )

          expect(response).to be_successful
          expect(response.body).not_to match(a1.notes)
          expect(response.body).to match(a2.notes)
          expect(response.body).not_to match(a3.notes)
        end
      end
    end

    describe "filtering by date" do
      it "renders a list of just today's AKI Alerts" do
        a1 = aki_alert(at: Time.zone.now)
        a2 = aki_alert(at: 1.day.ago)

        get renal_aki_alerts_path(
          q: {
            date_range: Renalware::Renal::AKIAlertSearchForm::DATE_RANGE_SPECIFIC_DATE,
            date: l(Time.zone.today)
          }
        )

        expect(response).to be_successful
        expect(response.body).to match(a1.notes)
        expect(response.body).not_to match(a2.notes)
      end
    end

    describe "filtered by hotlist" do
      it "renders a list of all AKI Alerts with hotlist=true" do
        a1 = aki_alert(at: Time.zone.now, hotlist: true)
        a2 = aki_alert(at: Time.zone.now, hotlist: false)

        get renal_aki_alerts_path(
          q: {
            date_range: Renalware::Renal::AKIAlertSearchForm::DATE_RANGE_ALL,
            on_hotlist: true
          }
        )

        expect(response).to be_successful
        expect(response.body).to match(a1.notes)
        expect(response.body).not_to match(a2.notes)
      end

      context "when a Print version requested" do
        it "renders a PDF" do
          get renal_aki_alerts_path(q: { on_hotlist: true }, format: :pdf)

          expect(response).to be_successful
          expect(response["Content-Type"]).to eq("application/pdf")
          expect(response["Content-Disposition"]).to include("inline")
          filename = "AKI Alerts #{l(Time.zone.today)}.pdf"
          expect(response["Content-Disposition"]).to include(filename)
        end
      end
    end
  end

  describe "GET edit" do
    it "renders the edit form" do
      patient = create(:renal_patient)
      alert = create(:aki_alert, notes: "abc", patient: patient, by: user)

      get edit_renal_aki_alert_path(alert, format: :html)

      expect(response).to be_successful
    end
  end

  describe "PATCH update" do
    context "with valid params" do
      it "update the alert" do
        action1 = create(:aki_alert_action, name: "action1")
        action2 = create(:aki_alert_action, name: "action2")
        alert = aki_alert(at: Time.zone.now, action: action1)

        attributes = {
          notes: "xyz",
          action_id: action2.id,
          hotlist: true,
          max_cre: 100,
          max_aki: 2,
          cre_date: Date.parse("01-Jan-2018"),
          aki_date: Date.parse("01-Feb-2018")
        }

        patch renal_aki_alert_path(alert), params: { renal_aki_alert: attributes }

        follow_redirect!

        expect(response).to be_successful
        expect(alert.reload).to have_attributes(
          action_id: action2.id,
          hotlist: true,
          notes: "xyz",
          max_cre: 100,
          cre_date: Date.parse("01-Jan-2018"),
          max_aki: 2,
          aki_date: Date.parse("01-Feb-2018")
        )
      end
    end
  end
end
