require 'spec_helper'

RSpec.describe Blabbermouth::Bystanders::Base do
  describe '#error' do
    it 'raises NotImplementedError' do
      expect { subject.error('key', StandardError.new) }.to raise_exception(NotImplementedError)
    end
  end

  describe '#info' do
    it 'raises NotImplementedError' do
      expect { subject.info('key', 'test') }.to raise_exception(NotImplementedError)
    end
  end

  describe '#increment' do
    it 'raises NotImplementedError' do
      expect { subject.increment('key', 1) }.to raise_exception(NotImplementedError)
    end
  end

  describe '#count' do
    it 'raises NotImplementedError' do
      expect { subject.count('key', 1) }.to raise_exception(NotImplementedError)
    end
  end

  describe '#time' do
    it 'raises NotImplementedError' do
      expect { subject.time('key', 1) }.to raise_exception(NotImplementedError)
    end
  end
end
