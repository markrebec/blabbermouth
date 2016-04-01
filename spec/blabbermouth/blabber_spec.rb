require 'spec_helper'

RSpec.describe Blabbermouth::Blabber do
  describe '#add_bystander!' do
    context 'when the bystander does not exist' do
      it 'adds a bystander to the list of bystanders' do
        subject.add_bystander!(:rails)
        expect(subject.bystanders.count).to eql(1)
        expect(subject.bystanders.first).to be_an_instance_of(Blabbermouth::Bystanders::Rails)
      end
    end
  end

  describe '#remove_bystander!' do
    context 'when the bystander exists' do
      it 'removes a bystander from the list of bystanders' do
        subject.add_bystander!(:rails)
        expect(subject.bystanders.count).to eql(1)
        subject.remove_bystander!(:rails)
        expect(subject.bystanders.count).to eql(0)
      end
    end
  end

  describe '#error' do
    it 'blabs to any added bystanders' do
      subject.add_bystander!(:test)
      subject.add_bystander!(:rails)
      subject.error('key', StandardError.new)
      expect(Blabbermouth::Bystanders::Test.logged?(:error, 'key', StandardError.new.message)).to be_true
      expect(Rails.logger.errors).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :error, 'key', StandardError.new))
    end
  end

  describe '#critical' do
    it 'blabs to any added bystanders' do
      subject.add_bystander!(:test)
      subject.add_bystander!(:rails)
      subject.critical('key', StandardError.new)
      expect(Blabbermouth::Bystanders::Test.logged?(:critical, 'key', StandardError.new.message)).to be_true
      expect(Rails.logger.errors).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :critical, 'key', StandardError.new))
    end
  end

  describe '#warning' do
    it 'blabs to any added bystanders' do
      subject.add_bystander!(:test)
      subject.add_bystander!(:rails)
      subject.warning('key', StandardError.new)
      expect(Blabbermouth::Bystanders::Test.logged?(:warning, 'key', StandardError.new.message)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :warning, 'key', StandardError.new))
    end
  end

  describe '#debug' do
    it 'blabs to any added bystanders' do
      subject.add_bystander!(:test)
      subject.add_bystander!(:rails)
      subject.debug('key', StandardError.new)
      expect(Blabbermouth::Bystanders::Test.logged?(:debug, 'key', StandardError.new.message)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :debug, 'key', StandardError.new))
    end
  end

  describe '#info' do
    it 'blabs to any added bystanders' do
      subject.add_bystander!(:test)
      subject.add_bystander!(:rails)
      subject.info('key', 'test')
      expect(Blabbermouth::Bystanders::Test.logged?(:info, 'key', 'test')).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :info, 'key', 'test'))
    end
  end

  describe '#increment' do
    it 'blabs to any added bystanders' do
      subject.add_bystander!(:test)
      subject.add_bystander!(:rails)
      subject.increment('key', 1)
      expect(Blabbermouth::Bystanders::Test.logged?(:increment, 'key', 1)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :increment, 'key', 1))
    end
  end

  describe '#count' do
    it 'blabs to any added bystanders' do
      subject.add_bystander!(:test)
      subject.add_bystander!(:rails)
      subject.count('key', 1)
      expect(Blabbermouth::Bystanders::Test.logged?(:count, 'key', 1)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :count, 'key', 1))
    end
  end

  describe '#time' do
    it 'blabs to any added bystanders' do
      subject.add_bystander!(:test)
      subject.add_bystander!(:rails)
      subject.time('key', 1)
      expect(Blabbermouth::Bystanders::Test.logged?(:time, 'key', 1)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :time, 'key', 1))
    end
  end

  describe '#method_missing' do
    context 'when added bystanders respond to the requested method' do
      it 'passes method calls through to added bystanders' do
        subject.add_bystander!(:test)
        subject.test('key', 'test')
        expect(Blabbermouth::Bystanders::Test.logged?(:test, 'key', 'test')).to be_true
      end
    end
  end

  describe '.error' do
    it 'blabs to any provided bystanders' do
      Blabbermouth::Blabber.error('key', StandardError.new, :test, :rails)
      expect(Blabbermouth::Bystanders::Test.logged?(:error, 'key', StandardError.new.message)).to be_true
      expect(Rails.logger.errors).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :error, 'key', StandardError.new))
    end
  end

  describe '.info' do
    it 'blabs to any provided bystanders' do
      Blabbermouth::Blabber.info('key', 'test', :test, :rails)
      expect(Blabbermouth::Bystanders::Test.logged?(:info, 'key', 'test')).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :info, 'key', 'test'))
    end
  end

  describe '.increment' do
    it 'blabs to any provided bystanders' do
      Blabbermouth::Blabber.increment('key', 1, :test, :rails)
      expect(Blabbermouth::Bystanders::Test.logged?(:increment, 'key', 1)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :increment, 'key', 1))
    end
  end

  describe '.count' do
    it 'blabs to any provided bystanders' do
      Blabbermouth::Blabber.count('key', 1, :test, :rails)
      expect(Blabbermouth::Bystanders::Test.logged?(:count, 'key', 1)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :count, 'key', 1))
    end
  end

  describe '.time' do
    it 'blabs to any provided bystanders' do
      Blabbermouth::Blabber.time('key', 1, :test, :rails)
      expect(Blabbermouth::Bystanders::Test.logged?(:time, 'key', 1)).to be_true
      expect(Rails.logger.infos).to include(Blabbermouth::Bystanders::Rails.new.send(:log_message, :time, 'key', 1))
    end
  end
end
