require 'blabbermouth-syslog'
require 'spec_helper'

RSpec.describe Blabbermouth::Bystanders::Syslog do
  let(:syslog) { subject.send(:syslog) }

  describe '#debug' do
    it 'posts to syslog' do
      expect(syslog).to receive(:debug)
      subject.debug('test.debug', 'test')
    end
  end

  describe '#error' do
    it 'posts to syslog' do
      expect(syslog).to receive(:error)
      subject.error('test.error', StandardError.new)
    end
  end

  describe '#fatal' do
    it 'posts to syslog' do
      expect(syslog).to receive(:fatal)
      subject.fatal('test.fatal', Exception.new)
    end
  end

  describe '#info' do
    it 'posts to syslog' do
      expect(syslog).to receive(:info)
      subject.info('test.info', 'test')
    end
  end

  describe '#info' do
    it 'posts to syslog' do
      expect(syslog).to receive(:unknown)
      subject.unknown('test.unknown', 'test')
    end
  end

  describe '#warn' do
    it 'posts to syslog' do
      expect(syslog).to receive(:warn)
      subject.warn('test.warn', 'test')
    end
  end

  describe '#increment' do
    it 'posts to syslog' do
      expect(syslog).to receive(:info)
      subject.increment('test.increment', 1)
    end
  end

  describe '#count' do
    it 'posts to syslog' do
      expect(syslog).to receive(:info)
      subject.count('test.count', 1)
    end
  end

  describe '#time' do
    it 'posts to syslog' do
      expect(syslog).to receive(:info)
      subject.time('test.time', 1)
    end
  end

  context 'when calling dynamic methods' do
    describe '#annotate' do
      it 'posts to syslog' do
        expect(syslog).to receive(:info)
        subject.annotate('test.annotate', 'test')
      end
    end
  end
end
