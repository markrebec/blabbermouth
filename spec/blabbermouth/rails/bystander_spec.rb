require 'blabbermouth-rails'
require 'spec_helper'

RSpec.describe Blabbermouth::Bystanders::Rails do
  it 'responds to dynamic event methods' do
    subject.custom('blabbermouth.test.custom')
    expect(Rails.logger.infos).to include(subject.send(:log_message, :custom, 'blabbermouth.test.custom', nil))
  end

  describe '#error' do
    it 'uses the rails logger' do
      subject.error('key', StandardError.new)
      expect(Rails.logger.errors).to include(subject.send(:log_message, :error, 'key', StandardError.new))
    end
  end

  describe '#critical' do
    it 'uses the rails logger' do
      subject.critical('key', StandardError.new)
      expect(Rails.logger.errors).to include(subject.send(:log_message, :critical, 'key', StandardError.new))
    end
  end

  describe '#warning' do
    it 'uses the rails logger' do
      subject.warning('key', 'test')
      expect(Rails.logger.infos).to include(subject.send(:log_message, :warning, 'key', 'test'))
    end
  end

  describe '#debug' do
    it 'uses the rails logger' do
      subject.debug('key', 'test')
      expect(Rails.logger.infos).to include(subject.send(:log_message, :debug, 'key', 'test'))
    end
  end

  describe '#info' do
    it 'uses the rails logger' do
      subject.info('key', 'test')
      expect(Rails.logger.infos).to include(subject.send(:log_message, :info, 'key', 'test'))
    end
  end

  describe '#increment' do
    it 'uses the rails logger' do
      subject.increment('key', 1)
      expect(Rails.logger.infos).to include(subject.send(:log_message, :increment, 'key', 1))
    end
  end

  describe '#count' do
    it 'uses the rails logger' do
      subject.count('key', 1)
      expect(Rails.logger.infos).to include(subject.send(:log_message, :count, 'key', 1))
    end
  end

  describe '#time' do
    it 'uses the rails logger' do
      subject.time('key', 1)
      expect(Rails.logger.infos).to include(subject.send(:log_message, :time, 'key', 1))
    end
  end
end
