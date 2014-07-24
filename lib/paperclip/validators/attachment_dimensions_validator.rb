module Paperclip
  module Validators
    class AttachmentDimensionsValidator < ActiveModel::EachValidator
      def initialize(options)
        super
      end

      def self.helper_method_name
        :validates_attachment_dimensions
      end

      def validate_each(record, attribute, value)
        return unless value.queued_for_write[:original]

        begin
          dimensions = Paperclip::Geometry.from_file(value.queued_for_write[:original].path)

          [:height, :width].each do |dimension|
            if options[dimension] && dimensions.send(dimension) != options[dimension].to_f
              record.errors.add(attribute.to_sym, :dimension, dimension_type: dimension.to_s, dimension: options[dimension], actual_dimension: dimensions.send(dimension).to_i)
            end
          end
        rescue Paperclip::Errors::NotIdentifiedByImageMagickError
          Paperclip.log("cannot validate dimensions on #{attribute}")
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
