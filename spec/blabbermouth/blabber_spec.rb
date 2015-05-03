require 'spec_helper'

RSpec.describe Blabbermouth::Blabber do
  describe '#add_gawker!' do
    context 'when the gawker does not exist' do
      it 'adds a gawker to the list of gawkers' do
        subject.add_gawker!(:rails)
        expect(subject.gawkers.count).to eql(1)
        expect(subject.gawkers.first).to be_an_instance_of(Blabbermouth::Gawkers::Rails)
      end
    end
  end

  describe '#remove_gawker!' do
    context 'when the gawker exists' do
      it 'removes a gawker from the list of gawkers' do
        subject.add_gawker!(:rails)
        expect(subject.gawkers.count).to eql(1)
        subject.remove_gawker!(:rails)
        expect(subject.gawkers.count).to eql(0)
      end
    end
  end

  describe '#error' do
    it 'blabs to any added gawkers' do
      subject.add_gawker!(:test)
      subject.add_gawker!(:rails)
      subject.error('key', StandardError.new)
      expect(Blabbermouth::Gawkers::Test.logged?(:error, 'key', StandardError.new.message)).to be_true
      expect(Rails.logger.errors).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :error, 'key', StandardError.new))
    end
  end

  describe '#info' do
    it 'blabs to any added gawkers' do
      subject.add_gawker!(:test)
      subject.add_gawker!(:rails)
      subject.info('key', 'test')
      expect(Blabbermouth::Gawkers::Test.logged?(:info, 'key', 'test')).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :info, 'key', 'test'))
    end
  end

  describe '#increment' do
    it 'blabs to any added gawkers' do
      subject.add_gawker!(:test)
      subject.add_gawker!(:rails)
      subject.increment('key', 1)
      expect(Blabbermouth::Gawkers::Test.logged?(:increment, 'key', 1)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :increment, 'key', 1))
    end
  end

  describe '#count' do
    it 'blabs to any added gawkers' do
      subject.add_gawker!(:test)
      subject.add_gawker!(:rails)
      subject.count('key', 1)
      expect(Blabbermouth::Gawkers::Test.logged?(:count, 'key', 1)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :count, 'key', 1))
    end
  end

  describe '#time' do
    it 'blabs to any added gawkers' do
      subject.add_gawker!(:test)
      subject.add_gawker!(:rails)
      subject.time('key', 1)
      expect(Blabbermouth::Gawkers::Test.logged?(:time, 'key', 1)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :time, 'key', 1))
    end
  end

  describe '#method_missing' do
    context 'when added gawkers respond to the requested method' do
      it 'passes method calls through to added gawkers' do
        subject.add_gawker!(:test)
        subject.test('key', 'test')
        expect(Blabbermouth::Gawkers::Test.logged?(:test, 'key', 'test')).to be_true
      end
    end
  end

  describe '.error' do
    it 'blabs to any provided gawkers' do
      Blabbermouth::Blabber.error('key', StandardError.new, :test, :rails)
      expect(Blabbermouth::Gawkers::Test.logged?(:error, 'key', StandardError.new.message)).to be_true
      expect(Rails.logger.errors).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :error, 'key', StandardError.new))
    end
  end

  describe '.info' do
    it 'blabs to any provided gawkers' do
      Blabbermouth::Blabber.info('key', 'test', :test, :rails)
      expect(Blabbermouth::Gawkers::Test.logged?(:info, 'key', 'test')).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :info, 'key', 'test'))
    end
  end

  describe '.increment' do
    it 'blabs to any provided gawkers' do
      Blabbermouth::Blabber.increment('key', 1, :test, :rails)
      expect(Blabbermouth::Gawkers::Test.logged?(:increment, 'key', 1)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :increment, 'key', 1))
    end
  end

  describe '.count' do
    it 'blabs to any provided gawkers' do
      Blabbermouth::Blabber.count('key', 1, :test, :rails)
      expect(Blabbermouth::Gawkers::Test.logged?(:count, 'key', 1)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :count, 'key', 1))
    end
  end

  describe '.time' do
    it 'blabs to any provided gawkers' do
      Blabbermouth::Blabber.time('key', 1, :test, :rails)
      expect(Blabbermouth::Gawkers::Test.logged?(:time, 'key', 1)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :time, 'key', 1))
    end
  end
end
