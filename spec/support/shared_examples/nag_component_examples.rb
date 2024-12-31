# Shared examples common to all nags where a nag defined in data in the nag_definitions table
# and displayed in the UI using the NagComponent.
shared_examples_for "a nag" do
  describe "#cache_key" do
    it "changes when patient or definition is touched" do
      component = described_class.new(definition: definition, patient: patient)

      expect(component.cache_key).not_to be_nil

      expect { patient.touch }.to change(component, :cache_key)
      expect { definition.touch }.to change(component, :cache_key)
    end

    it "always expires after a configured number of minutes" do
      nag = create_nag(severity: :low)

      allow(definition)
        .to receive(:execute_sql_function_for).with(patient)
        .and_return(nag)

      allow(nag).to receive(:value).and_return("original-value")

      component = described_class.new(definition: definition, patient: patient)

      render_inline(component)

      expect(page).to have_content("original-value")

      # Update value
      allow(component).to receive(:value).and_return("new-value")

      # should render old value up until the expiry time
      travel_to (component.always_expire_cache_after_seconds.seconds - 1.minute).from_now do
        render_inline(component)
        expect(page).to have_content("original-value")
      end

      # should render new value after the expiry time
      travel_to (component.always_expire_cache_after_seconds.seconds + 1.minute).from_now do
        render_inline(component)
        expect(page).to have_content("new-value")
      end
    end
  end

  describe "displaying severity" do
    it "adds a css class to the markup to style the color and icon used for each severity" do
      nag = create_nag(severity: :high)
      allow(definition)
        .to receive(:execute_sql_function_for).with(patient)
        .and_return(nag)
      component = described_class.new(definition: definition, patient: patient)

      render_inline(component)

      expect(page.first(".patient-nag-severity-high")).not_to be_nil
    end
  end

  describe "#render?" do
    it "does not render when definition#enabled is false" do
      nag = create_nag(severity: :high)
      allow(definition).to receive(:execute_sql_function_for).with(patient).and_return(nag)
      allow(definition).to receive(:enabled).and_return(false)
      component = described_class.new(definition: definition, patient: patient)

      expect(component.render?).to be(false)
    end

    context "when there was an error rendering the sql function" do
      it "returns true but will render as hidden" do
        # Passing a nil patient will cause an error formatting the SQL function call
        component = described_class.new(definition: definition, patient: nil)

        expect(component.sql_error).not_to be_nil
      end
    end

    [
      { date: "", value: "x", severity: :high, render: true, contains: "x" },
      { date: "2016-01-01", value: "x", severity: :high, render: true, contains: "01-Jan-2016" },
      { date: "2016-01-01", value: "x", severity: :medium, render: true, contains: "01-Jan-2016" },
      { date: "2016-01-01", value: "x", severity: :low, render: true, contains: "01-Jan-2016" },
      { date: "2016-01-01", value: "x", severity: :info, render: true, contains: "01-Jan-2016" },
      { date: "2016-01-01", value: nil, severity: :info, render: true, contains: "01-Jan-2016" },
      { date: nil, value: nil, severity: :high, render: true, contains: "" },
      { date: "", value: "Missing", severity: :high, render: true, contains: "Missing" },
      { date: "2016-01-01", value: "x", severity: :none, render: false, contains: "" }
    ].each do |opts|
      msg = opts[:render] ? "renders" : "does not not render"

      it "#{msg} when nag#attributes = #{opts.except(:render)}" do
        nag = create_nag(**opts.except(:render, :contains))
        allow(definition).to receive(:execute_sql_function_for).with(patient).and_return(nag)
        component = described_class.new(definition: definition, patient: patient)

        expect(component.render?).to eq(opts[:render])

        render_inline(component)

        expect(page).to have_content(opts[:contains])
      end
    end
  end
end
