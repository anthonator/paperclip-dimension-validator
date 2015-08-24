require 'rubygems'
require 'rspec'
require 'active_record'
require 'chunky_png'
require 'awesome_print'
require 'paperclip'
require "paperclip-dimension-validator"
require 'pry'
require 'rails'

ROOT = Pathname(File.expand_path(File.join(File.dirname(__FILE__), '..')))

$LOAD_PATH << File.join(ROOT, 'lib')
$LOAD_PATH << File.join(ROOT, 'lib', 'paperclip')
require "paperclip/matchers/validate_attachment_dimensions_matcher.rb"

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config['test'])
Paperclip.options[:logger] = ActiveRecord::Base.logger

Dir[File.join(ROOT, 'spec', 'support', '**', '*.rb')].each{|f| require f }

ActiveSupport::Deprecation.silenced = true
I18n.available_locales = [:en, :ru]

RSpec.configure do |config|
  config.include ModelReconstruction
  config.before(:all) do
    rebuild_model
  end
end
