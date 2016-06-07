require 'i18n'

module Paperclip
  module Validators
    class AttachmentDimensionsValidator < ActiveModel::EachValidator
      def initialize(options)
        super(options)
      end

      def self.helper_method_name
        :validates_attachment_dimensions
      end

      def validate_each(record, attribute, value)
        return unless value.queued_for_write[:original]

        begin
          file_path = value.queued_for_write[:original].path
          dimensions = Paperclip::Geometry.from_file(file_path)
          validate_attachment(record, attribute, dimensions)
        rescue Paperclip::Errors::NotIdentifiedByImageMagickError
          Paperclip.log("cannot validate dimensions on #{attribute}")
        end
      end

      protected

      def validate_attachment(record, attribute, dimensions)
        %i(height width).each do |dimension|
          return unless options[dimension]
          value = dimensions.send(dimension).to_i

          unless valid?(options[dimension], value)
            record.errors.add(
              attribute.to_sym,
              :dimension,
              dimension_type:   I18n.t("dimension_types.#{dimension}"),
              dimension:        options[dimension],
              actual_dimension: value
            )
          end
        end
      end

      def valid?(validation, value)
        if [Array, Range].include? validation.class
          validation.include? value
        else
          value != validation.to_f
        end
      end
    end

    module HelperMethods
      def validates_attachment_dimensions(*attr_names)
        options = _merge_attributes(attr_names)
        validates_with(AttachmentDimensionsValidator, options.dup)
        validate_before_processing(AttachmentDimensionsValidator, options.dup)
      end
    end
  end
end
