require 'active_model'
require 'paperclip/validators'
require 'paperclip/validators/attachment_dimensions_validator'

locale_path = Dir.glob(File.dirname(__FILE__) + "/locales/*.{rb,yml}")
I18n.load_path += locale_path unless I18n.load_path.include?(locale_path)
