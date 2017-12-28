ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../../config/environment", __FILE__)
require 'rspec/core'
require 'rspec/rails'
require 'capybara/rspec'
require 'billy/capybara/rspec'

require 'rack/utils'

Capybara.app = Rack::ShowExceptions.new(Sample::Application)

Capybara.configure do |config|
  config.default_driver = :webkit_billy
  config.default_max_wait_time = 10
end

Capybara::Screenshot.register_driver(:webkit_billy) do |driver, path|
  driver.save_screenshot(path)
end

Capybara::Webkit.configure do |config|
  config.allow_unknown_urls
end

RSpec.configure do |config|
  config.include Capybara::DSL
end

describe 'Actions' do

  it 'stub for HTTP working' do
    url = 'http://api.github.com/'
    file = file_fixture('test.json').read
    hash = JSON.parse(file)
    proxy.stub(url).and_return(headers: { 'Access-Control-Allow-Origin' => '*'}, json: hash)

    visit '/actions/index'
    sleep 3
    p page.driver.console_messages
    screenshot_and_open_image
    expect(page).to have_css('.http', text: 'expected_value')
  end

  it 'stub for HTTPS NOT working' do
    url = 'https://api.github.com:443/'
    file = file_fixture('test.json').read
    hash = JSON.parse(file)
    proxy.stub(url).and_return(headers: { 'Access-Control-Allow-Origin' => '*'}, json: hash)

    visit '/actions/index'
    sleep 3
    p page.driver.console_messages
    screenshot_and_open_image
    expect(page).to have_css('.https', text: 'expected_value')
  end
end