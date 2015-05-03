require 'spec_helper'

RSpec.describe Blabbermouth::Gawkers::Rollbar do
  describe '#error' do
    it 'reports to rollbar' do
      subject.error('key', StandardError.new)
      error = ::Rollbar.errors.last
      expect(error[0]).to be_an_instance_of(Blabbermouth::Error)
    end
  end

  describe '#info' do
    it 'reports to rollbar' do
      subject.info('key', 'test')
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Info)
    end
  end

  describe '#increment' do
    it 'reports to rollbar' do
      subject.increment('key', 1)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Increment)
    end
  end

  describe '#count' do
    it 'reports to rollbar' do
      subject.count('key', 1)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Count)
    end
  end

  describe '#time' do
    it 'reports to rollbar' do
      subject.time('key', 1)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Time)
    end
  end
end
