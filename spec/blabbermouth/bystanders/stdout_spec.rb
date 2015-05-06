require 'spec_helper'

RSpec.describe Blabbermouth::Bystanders::Stdout do
  describe '#error' do
    it 'outputs to STDOUT' do
      expect(capture_stdout { subject.error('key', StandardError.new) }).to eql(subject.send(:log_message, :error, 'key', StandardError.new))
    end

    it 'accepts a data hash' do
      expect(capture_stdout { subject.error('test.error', StandardError.new, data: {test: :argument}) }).to eql(subject.send(:log_message, :error, 'test.error', StandardError.new, {test: :argument}))
    end
  end

  describe '#info' do
    it 'outputs to STDOUT' do
      expect(capture_stdout { subject.info('key', 'test') }).to eql(subject.send(:log_message, :info, 'key', 'test'))
    end

    it 'accepts a data hash' do
      expect(capture_stdout { subject.info('test.info', 'test data', data: {test: :argument}) }).to eql(subject.send(:log_message, :info, 'test.info', 'test data', {test: :argument}))
    end
  end

  describe '#increment' do
    it 'outputs to STDOUT' do
      expect(capture_stdout { subject.increment('key', 1) }).to eql(subject.send(:log_message, :increment, 'key', 1))
    end

    it 'accepts a data hash' do
      expect(capture_stdout { subject.increment('test.increment', 1, data: {test: :argument}) }).to eql(subject.send(:log_message, :increment, 'test.increment', 1, {test: :argument}))
    end
  end

  describe '#count' do
    it 'outputs to STDOUT' do
      expect(capture_stdout { subject.count('key', 1) }).to eql(subject.send(:log_message, :count, 'key', 1))
    end

    it 'accepts a data hash' do
      expect(capture_stdout { subject.count('test.count', 1, data: {test: :argument}) }).to eql(subject.send(:log_message, :count, 'test.count', 1, {test: :argument}))
    end
  end

  describe '#time' do
    it 'outputs to STDOUT' do
      expect(capture_stdout { subject.time('key', 1) }).to eql(subject.send(:log_message, :time, 'key', 1))
    end

    it 'accepts a data hash' do
      expect(capture_stdout { subject.time('test.time', 1, data: {test: :argument}) }).to eql(subject.send(:log_message, :time, 'test.time', 1, {test: :argument}))
    end
  end
end
