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
          @subject.valid?
          @subject.errors[@attachment_name].include?("must have a height of #{@height}px was #{height}px")
        end

        def validation_with_width(width)
          @subject.send(@attachment_name).assign(generate_png(@height, width))
          @subject.valid?
          @subject.errors[@attachment_name].include?("must have a width of #{@width}px was #{width}px")
        end

        def shorter_than_height?
          @height.nil? || validation_with_height(@height - 1)
        end

        def taller_than_height?
          @height.nil? || validation_with_height(@height + 1)
        end

        def smaller_than_width?
          @width.nil? || validation_with_width(@width - 1)
        end

        def larger_than_width?
          @width.nil? || validation_with_width(@width + 1)
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
