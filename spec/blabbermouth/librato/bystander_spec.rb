require 'blabbermouth-librato'
require 'spec_helper'

RSpec.describe Blabbermouth::Bystanders::Librato do
  describe '#error' do
    it 'posts to librato' do
      subject.error('test.error', StandardError.new)
      expect(Librato.increments['test.error']).to eql(1)
    end
  end

  describe '#annotate' do
    it 'posts to librato' do
      subject.annotate('test.annotate', 'test')
      expect(Librato::Metrics.annotations['test.annotate']).to include('test')
    end
  end

  describe '#info' do
    it 'posts to librato' do
      subject.info('test.info', 'test')
      expect(Librato.increments['test.info']).to eql(1)
    end
  end

  describe '#increment' do
    it 'posts to librato' do
      subject.increment('test.increment', 1)
      expect(Librato.increments['test.increment']).to eql(1)
    end
  end

  describe '#count' do
    it 'posts to librato' do
      subject.count('test.count', 1)
      expect(Librato.measurements['test.count']).to include(1)
    end
  end

  describe '#time' do
    it 'posts to librato' do
      subject.time('test.time', 1)
      expect(Librato.timings['test.time']).to include(1)
    end
  end
end
