require File.expand_path('../../test_helper', __FILE__)
require 'rails/generators'
require File.expand_path('../../../lib/generators/janus/install_generator', __FILE__)

class Janus::Generators::InstallGeneratorTest < Rails::Generators::TestCase
  tests Janus::Generators::InstallGenerator

  destination Rails.root.join('tmp').to_s
  setup :prepare_destination

  test "create" do
    run_generator
    assert_file 'config/initializers/janus.rb'
    assert_file 'config/locales/janus.en.yml'
  end
end
