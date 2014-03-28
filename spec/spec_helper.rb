require 'bundler/setup'
Bundler.require(:default, :test)

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file }

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))['test'])

RSpec.configure do |config|
  config.after(:each) do
  Event.all.each{ |event| event.destroy}
  Task.all.each{ |task| task.destroy}
  Note.all.each{|note| note.destroy}
  end
end
