module Blabbermouth
  class Railtie < Rails::Railtie
    initializer 'blabbermouth.configure_rails_gawker' do
      Blabbermouth.configure do |config|
        config.gawkers = [:rails]
      end
    end
  end
end
