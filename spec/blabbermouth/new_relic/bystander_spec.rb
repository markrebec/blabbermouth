require 'blabbermouth-new_relic'
require 'spec_helper'

RSpec.describe Blabbermouth::Bystanders::NewRelic do
  before do
    stub_const("::NewRelic::Agent", double)
    allow(::NewRelic::Agent).to receive(:notice_error)
    allow(::NewRelic::Agent).to receive(:record_custom_event)
    allow(::NewRelic::Agent).to receive(:increment_metric)
    allow(::NewRelic::Agent).to receive(:record_metric)
  end

  describe '#error' do
    it 'posts to new relic' do
      expect(::NewRelic::Agent).to receive(:notice_error).with(StandardError.new, {key: 'test.error'})
      subject.error('test.error', StandardError.new)
    end
  end

  describe '#info' do
    it 'posts to new relic' do
      expect(::NewRelic::Agent).to receive(:record_custom_event).with('test.info', {message: 'test'})
      subject.info('test.info', 'test')
    end
  end

  describe '#increment' do
    it 'posts to new relic' do
      expect(::NewRelic::Agent).to receive(:increment_metric).with('test.increment', 1)
      subject.increment('test.increment', 1)
    end
  end

  describe '#count' do
    it 'posts to new relic' do
      expect(::NewRelic::Agent).to receive(:record_metric).with('test.count', 1)
      subject.count('test.count', 1)
    end
  end

  describe '#time' do
    it 'posts to new relic' do
      expect(::NewRelic::Agent).to receive(:record_custom_event).with('test.time', {duration: 1})
      subject.time('test.time', 1)
    end
  end
end
