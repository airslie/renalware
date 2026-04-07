module Renalware
  class Patients::TimelineComponent < Base
    SUMMARY_LIMIT = 6

    def initialize(patient:, **attrs)
      @patient = patient
      @page = attrs[:page]
      @full_view = attrs[:full_view]
      super
    end

    def render? = true

    def view_template
      @pagy, @items = items

      div(class: "summary-part--timeline") do
        article do
          article_header unless @full_view
          Table(class: %w(toggleable), data: { controller: "toggle" }) do
            table_header
            @items.each { render from_model(it) }
          end
          raw(@pagy.series_nav.html_safe) if @full_view
        end
      end
    end

    private

    def items
      pagy_custom Renalware::Patients::Timeline.all(@patient)
    end

    def pagy_custom(collection, vars = {})
      limit = @full_view ? nil : SUMMARY_LIMIT
      options = vars.merge(request:)

      pagy = Pagy::Offset.new(count: collection.count, page: @page, limit:, **options)
      [pagy, collection.offset(pagy.offset, limit: pagy.limit)]
    end

    # TODO: Consider moving out as a separate component
    def rows_toggler
      a(
        href: "#",
        data: { action: "toggle#table", turbo: "false" },
        class: "toggler",
        title: "Toggle all rows"
      ) { i }
    end

    # TODO: Component?
    def count
      actual = @items.count
      total = @pagy.count
      total > actual ? "#{actual} of #{total}" : actual
    end

    def article_header
      header do
        h1 do
          a(href: patient_timeline_path(@patient)) do
            "Activity Summary (#{count})"
          end
        end
      end
    end

    def table_header
      TableHeader do
        TableRow do
          TableHead(class: %w(togglers noprint)) { rows_toggler }
          TableHead(class: %w(col-width-medium font-bold)) { "Date" }
          TableHead(class: "font-bold") { "Type" }
          TableHead(class: "font-bold") { "Description" }
          TableHead(class: %w(col-width-medium font-bold)) { "Created by" }
        end
      end
    end

    def from_model(item)
      row_class = NameService.from_model(item.record, to: "TimelineRow")
      render row_class.new(sort_date: item.sort_date, record: item.record)
    end
  end
end
