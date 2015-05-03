require 'spec_helper'

RSpec.describe Blabbermouth::Gawkers::Stdout do
  describe '#error' do
    it 'outputs to STDOUT' do
      expect(capture_stdout { subject.error('key', StandardError.new) }).to eql(subject.send(:log_message, :error, 'key', StandardError.new))
    end
  end

  describe '#info' do
    it 'outputs to STDOUT' do
      expect(capture_stdout { subject.info('key', 'test') }).to eql(subject.send(:log_message, :info, 'key', 'test'))
    end
  end

  describe '#increment' do
    it 'outputs to STDOUT' do
      expect(capture_stdout { subject.increment('key', 1) }).to eql(subject.send(:log_message, :increment, 'key', 1))
    end
  end

  describe '#count' do
    it 'outputs to STDOUT' do
      expect(capture_stdout { subject.count('key', 1) }).to eql(subject.send(:log_message, :count, 'key', 1))
    end
  end

  describe '#time' do
    it 'outputs to STDOUT' do
      expect(capture_stdout { subject.time('key', 1) }).to eql(subject.send(:log_message, :time, 'key', 1))
    end
  end
end
