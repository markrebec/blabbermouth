require 'spec_helper'

RSpec.describe Blabbermouth do
  describe '#error' do
    it 'blabs to any provided bystanders' do
      subject.error('key', StandardError.new, :rollbar, :rails)
      error = ::Rollbar.errors.last
      expect(error[0]).to be_an_instance_of(Blabbermouth::Error)
      expect(Rails.logger.errors).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :error, 'key', StandardError.new))
    end
  end

  describe '#info' do
    it 'blabs to any provided bystanders' do
      subject.info('key', 'test', :rollbar, :rails)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Info)
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :info, 'key', 'test'))
    end
  end

  describe '#increment' do
    it 'blabs to any provided bystanders' do
      subject.increment('key', 1, :rollbar, :rails)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Increment)
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :increment, 'key', 1))
    end
  end

  describe '#count' do
    it 'blabs to any provided bystanders' do
      subject.count('key', 1, :rollbar, :rails)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Count)
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :count, 'key', 1))
    end
  end

  describe '#time' do
    it 'blabs to any provided bystanders' do
      subject.time('key', 1, :rollbar, :rails)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Time)
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :time, 'key', 1))
    end
  end
end
