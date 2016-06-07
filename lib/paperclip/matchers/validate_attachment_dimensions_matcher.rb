require 'tempfile'
require 'i18n'

module Paperclip
  module Shoulda
    module Matchers
      def validate_attachment_dimensions(name)
        ValidateAttachmentDimensionsMatcher.new(name)
      end

      class ValidateAttachmentDimensionsMatcher
        def initialize(attachment_name)
          unless defined?(ChunkyPNG)
            puts "WARNING: Add chunky_png or oily_png to your Gemfile to use paperclip dimension matchers"
          end

          @attachment_name = attachment_name
        end

        def height(height)
          @height = height
          self
        end

        def width(width)
          @width = width
          self
        end

        def matches?(subject)
          @subject = subject
          @subject = @subject.new if @subject.class == Class
          shorter_than_height? && taller_than_height? && smaller_than_width? && larger_than_width?
        end

        def failure_message
          message = "Attachment #{@attachment_name} must have"
          message += " a height of #{@height}px" if @height
          message += " and" if @height && @width
          message += " a width of #{@width}px" if @width
        end

        def failure_message_when_negated
          message = "Attachment #{@attachment_name} cannot have"
          message += " a height of #{@height}px" if @height
          message += " and" if @height && @width
          message += " a width of #{@width}px" if @width
        end
        alias negative_failure_message failure_message_when_negated

        def description
          "validate width and height in pixels for attachment #{@attachment_name}"
        end

        protected

        def validation_with_height(height)
          @subject.send(@attachment_name).assign(generate_png(height, @width))
          error_added?('height', @height, height)
        end

        def validation_with_width(width)
          @subject.send(@attachment_name).assign(generate_png(@height, width))
          error_added?('width', @width, width)
        end

        def shorter_than_height?
          return if @height.nil?
          height = @height.respond_to?(:first) ? @height.first : @height
          validation_with_height(height - 1)
        end

        def taller_than_height?
          return if @height.nil?
          height = @height.respond_to?(:last) ? @height.last : @height
          validation_with_height(height + 1)
        end

        def smaller_than_width?
          return if @width.nil?
          width = @width.respond_to?(:first) ? @width.first : @width
          validation_with_width(width - 1)
        end

        def larger_than_width?
          return if @width.nil?
          width = @width.respond_to?(:last) ? @width.last : @width
          validation_with_width(width + 1)
        end

        def generate_png(height, width)
          file = Tempfile.new("#{Time.now.to_i}.png")
          file.binmode
          save_image(
            file.path,
            width.try(:first) || width,
            height.try(:first) || height
          )
          file
        end

        def save_image(file_path, width, height)
          image = ChunkyPNG::Image.new(
            width || 1,
            height || 1,
            ChunkyPNG::Color('black')
          )

          image.save(file_path)
        end

        def error_added?(dimension_type, dimension, actual_dimension)
          @subject.valid?

          @subject.errors.added?(
            @attachment_name,
            :dimension,
            dimension_type:   I18n.t("dimension_types.#{dimension_type}"),
            dimension:        instance_variable_get("@#{dimension_type}"),
            actual_dimension: actual_dimension
          )
        end
      end
    end
  end
end
