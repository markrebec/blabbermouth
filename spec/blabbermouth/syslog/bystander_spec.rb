require 'blabbermouth-syslog'
require 'spec_helper'

RSpec.describe Blabbermouth::Bystanders::Syslog do
  describe '#error' do
    xit 'posts to syslog' do
      subject.error('test.error', StandardError.new)
    end
  end

  describe '#annotate' do
    xit 'posts to syslog' do
      subject.annotate('test.annotate', 'test')
    end
  end

  describe '#info' do
    xit 'posts to syslog' do
      subject.info('test.info', 'test')
    end
  end

  describe '#increment' do
    xit 'posts to syslog' do
      subject.increment('test.increment', 1)
    end
  end

  describe '#count' do
    xit 'posts to syslog' do
      subject.count('test.count', 1)
    end
  end

  describe '#time' do
    xit 'posts to syslog' do
      subject.time('test.time', 1)
    end
  end
end
