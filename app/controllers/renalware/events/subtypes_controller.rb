module Renalware
  module Events
    class SubtypesController < BaseController
      class FieldInfo
        include ActiveModel::Model

        attr_accessor :name, :label, :position
      end

      def index
        subtypes = event_type.subtypes.includes(:updated_by).order(name: :asc)
        authorize subtypes
        render locals: { event_type: event_type, subtypes: subtypes }
      end

      def new
        subtype = event_type.subtypes.new
        subtype.definition = []
        authorize subtype
        render_new(subtype)
      end

      def edit
        subtype = event_type.subtypes.find(params[:id])
        authorize subtype
        render_edit(subtype)
      end

      def create
        subtype = event_type.subtypes.new(layout_params)
        subtype.definition = parse_definition_params_into_useable_hash
        authorize subtype

        if subtype.save
          redirect_to events_type_subtypes_path(event_type)
        else
          render_new(subtype)
        end
      end

      def update
        subtype = event_type.subtypes.find(params[:id])
        subtype.definition = parse_definition_params_into_useable_hash
        authorize subtype

        subtype.assign_attributes(layout_params)

        if subtype.valid?
          # layout.restore_attributes
          subtype.supersede!(layout_params)
          redirect_to events_type_subtypes_path(event_type)
        else
          render_edit(subtype)
        end
      end

      private

      def render_edit(subtype)
        subtype.fields = target_klass_attributes(subtype)
        render :edit, locals: { subtype: subtype }
      end

      def render_new(subtype)
        subtype.fields = target_klass_attributes(subtype)
        render :new, locals: { subtype: subtype }
      end

      # Things to watch here
      # - new attrs might have been added to target_klass_attributes and they will
      #   not be in layout.definition array
      # rubocop:disable Metrics/AbcSize
      def target_klass_attributes(layout)
        labels_hash = definition_to_simple_field_label_hash(layout) || {}
        klass = "#{layout.event_type.event_class_name}::Document".constantize.new

        # 1 Remove obsolete attrs that are no longer attributes on the object called class_name
        obsolete_attrs = labels_hash.keys - klass.attributes.keys.map(&:to_s)
        labels_hash.except!(*obsolete_attrs)

        # 1. Build field_infos using existing layout definition if there is one.
        # Note this will only really be significant if we are editing a layout
        # otherwise labels_hash is empty
        field_infos = labels_hash.map.with_index do |arr, idx|
          name, label = arr
          FieldInfo.new(
            name: name,
            label: label,
            position: idx
          )
        end

        # 2. Add any fields that are missing - will be all of them if this is a new layout
        #    otherwise, if we are editing, if will be just any new attrs added to the object with
        #    layoutable.class_name since the layout was last updated.
        klass.attributes.keys.map do |attr|
          next if labels_hash.key?(attr.to_s)

          field_infos << FieldInfo.new(
            name: attr,
            label: labels_hash[attr.to_s],
            position: 0
          )
        end

        field_infos
      end
      # rubocop:enable Metrics/AbcSize

      # Converts
      # [{"number1"=>{"label"=>"sd"}}, {"text1"=>{"label"=>"dsd"}}, ..
      # to
      # {"number1"=>"sd", "text1"=>"dsd", ...
      # Order is maintained
      def definition_to_simple_field_label_hash(layout)
        layout.definition.each_with_object(ActiveSupport::OrderedHash.new) do |field, hash|
          hash[field.keys[0]] = field.values[0]["label"]
        end
      end

      def event_type
        @event_type ||= Events::Type.find(params[:type_id])
      end

      # Parse the field labels and positions in params into a format we can digest
      def parse_definition_params_into_useable_hash
        request
          .params
          .to_h["layout"]["fields"].each_with_object([]) { |k, arr| arr << { k[0] => k[1] } }
      end

      def layout_params
        params
          .require(:layout)
          .permit!
          .merge(by: current_user)
      end
    end
  end
end
