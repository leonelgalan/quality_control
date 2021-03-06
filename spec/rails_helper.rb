ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

ActiveRecord::Base.logger = Logger.new(STDOUT) if ENV['AR_LOGGER']

RSpec.configure(&:infer_spec_type_from_file_location!)
