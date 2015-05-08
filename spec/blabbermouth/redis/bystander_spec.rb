require 'blabbermouth-redis'
require 'spec_helper'

RSpec.describe Blabbermouth::Bystanders::Redis do
  describe '#error' do
    xit 'stores the value in redis' do
      subject.error('blabbermouth.test.error', StandardError.new)
    end
  end

  describe '#info' do
    xit 'stores the value in redis' do
      subject.info('blabbermouth.test.info', 'test')
    end
  end

  describe '#increment' do
    xit 'stores the value in redis' do
      subject.increment('blabbermouth.test.increment', 1)
    end
  end

  describe '#count' do
    xit 'stores the value in redis' do
      subject.count('blabbermouth.test.count', 1)
    end
  end

  describe '#time' do
    xit 'stores the value in redis' do
      subject.time('blabbermouth.test.time', 1)
    end
  end
end
