require 'blabbermouth-new_relic'
require 'spec_helper'

RSpec.describe Blabbermouth::Bystanders::NewRelic do
  describe '#error' do
    xit 'posts to new relic' do
      subject.error('test.error', StandardError.new)
    end
  end

  describe '#info' do
    xit 'posts to new relic' do
      subject.info('test.info', 'test')
    end
  end

  describe '#increment' do
    xit 'posts to new relic' do
      subject.increment('test.increment', 1)
    end
  end

  describe '#count' do
    xit 'posts to new relic' do
      subject.count('test.count', 1)
    end
  end

  describe '#time' do
    xit 'posts to new relic' do
      subject.time('test.time', 1)
    end
  end
end
