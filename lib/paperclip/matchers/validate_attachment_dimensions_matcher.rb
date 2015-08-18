require 'tempfile'

module Paperclip
  module Shoulda
    module Matchers
      def validate_attachment_dimensions(name)
        ValidateAttachmentDimensionsMatcher.new(name)
      end

      class ValidateAttachmentDimensionsMatcher
        def initialize(attachment_name)
          unless defined?(ChunkyPNG)
            puts 'WARNING: Add chunky_png or oily_png to your Gemfile to use paperclip dimension matchers'
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
          validate_invalid_sizes(subject) && validate_valid_sizes(subject)
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
        def validate_invalid_sizes subject
          shorter_than_height?(subject) && taller_than_height?(subject) && smaller_than_width?(subject) && larger_than_width?(subject)
        end

        def validate_valid_sizes subject
          subject = create_subject subject
          !validation_with_height(@height, subject) || !validation_with_width(@width, subject)
        end

        def validation_with_height(height, subject)
          subject.send(@attachment_name).assign(generate_png(height, @width))
          subject.valid?
          subject.errors.added? @attachment_name, :dimension, dimension_type: :height, dimension: @height, actual_dimension: height
        end

        def validation_with_width(width, subject)
          subject.send(@attachment_name).assign(generate_png(@height, width))
          subject.valid?
          subject.errors.added? @attachment_name, :dimension, dimension_type: :width, dimension: @width, actual_dimension: width
        end

        def shorter_than_height? subject
          @height.nil? || validation_with_height(@height - 1, create_subject(subject))
        end

        def taller_than_height? subject
          @height.nil? || validation_with_height(@height + 1, create_subject(subject))
        end

        def smaller_than_width? subject
          @width.nil? || validation_with_width(@width - 1, create_subject(subject))
        end

        def larger_than_width? subject
          @width.nil? || validation_with_width(@width + 1, create_subject(subject))
        end

        def create_subject subject_klass
          subject_klass.new if subject_klass.class == Class
        end

        def generate_png(height, width)
          file = Tempfile.new([Time.now.to_i.to_s, '.png'])
          file.binmode
          ChunkyPNG::Image.new(width || 1, height || 1, ChunkyPNG::Color('black')).save(file.path)
          file
        end
      end
    end
  end
end
