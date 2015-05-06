module Blabbermouth
  class Railtie < Rails::Railtie
    initializer 'blabbermouth.configure_rails_bystander' do
      Blabbermouth.configure do |config|
        config.bystanders = [:rails]
      end
    end
  end
end
