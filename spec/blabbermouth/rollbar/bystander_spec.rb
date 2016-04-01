require 'blabbermouth-rollbar'
require 'spec_helper'

RSpec.describe Blabbermouth::Bystanders::Rollbar do
  describe '#error' do
    it 'reports to rollbar' do
      subject.error('key', StandardError.new)
      error = ::Rollbar.errors.last
      expect(error[0]).to be_an_instance_of(Blabbermouth::Error)
    end
  end

  describe '#critical' do
    it 'reports to rollbar' do
      subject.critical('key', StandardError.new)
      critical = ::Rollbar.criticals.last
      expect(critical[0]).to be_an_instance_of(Blabbermouth::Critical)
    end
  end

  describe '#warning' do
    it 'reports to rollbar' do
      subject.warning('key', StandardError.new)
      warning = ::Rollbar.warnings.last
      expect(warning[0]).to be_an_instance_of(Blabbermouth::Warning)
    end
  end

  describe '#debug' do
    it 'reports to rollbar' do
      subject.debug('key', StandardError.new)
      debug = ::Rollbar.debugs.last
      expect(debug[0]).to be_an_instance_of(Blabbermouth::Debug)
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
