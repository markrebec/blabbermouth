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
      subject.add_gawker!(:rollbar)
      subject.add_gawker!(:rails)
      subject.error('key', StandardError.new)
      error = ::Rollbar.errors.last
      expect(error[0]).to be_an_instance_of(Blabbermouth::Error)
      expect(Rails.logger.errors).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :error, 'key', StandardError.new))
    end
  end

  describe '#info' do
    it 'blabs to any added gawkers' do
      subject.add_gawker!(:rollbar)
      subject.add_gawker!(:rails)
      subject.info('key', 'test')
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Info)
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :info, 'key', 'test'))
    end
  end

  describe '#increment' do
    it 'blabs to any added gawkers' do
      subject.add_gawker!(:rollbar)
      subject.add_gawker!(:rails)
      subject.increment('key', 1)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Increment)
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :increment, 'key', 1))
    end
  end

  describe '#count' do
    it 'blabs to any added gawkers' do
      subject.add_gawker!(:rollbar)
      subject.add_gawker!(:rails)
      subject.count('key', 1)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Count)
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :count, 'key', 1))
    end
  end

  describe '#time' do
    it 'blabs to any added gawkers' do
      subject.add_gawker!(:rollbar)
      subject.add_gawker!(:rails)
      subject.time('key', 1)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Time)
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :time, 'key', 1))
    end
  end

  describe '.error' do
    it 'blabs to any provided gawkers' do
      Blabbermouth::Blabber.error('key', StandardError.new, :rollbar, :rails)
      error = ::Rollbar.errors.last
      expect(error[0]).to be_an_instance_of(Blabbermouth::Error)
      expect(Rails.logger.errors).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :error, 'key', StandardError.new))
    end
  end

  describe '.info' do
    it 'blabs to any provided gawkers' do
      Blabbermouth::Blabber.info('key', 'test', :rollbar, :rails)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Info)
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :info, 'key', 'test'))
    end
  end

  describe '.increment' do
    it 'blabs to any provided gawkers' do
      Blabbermouth::Blabber.increment('key', 1, :rollbar, :rails)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Increment)
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :increment, 'key', 1))
    end
  end

  describe '.count' do
    it 'blabs to any provided gawkers' do
      Blabbermouth::Blabber.count('key', 1, :rollbar, :rails)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Count)
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :count, 'key', 1))
    end
  end

  describe '.time' do
    it 'blabs to any provided gawkers' do
      Blabbermouth::Blabber.time('key', 1, :rollbar, :rails)
      info = ::Rollbar.infos.last
      expect(info[0]).to be_an_instance_of(Blabbermouth::Time)
      expect(Rails.logger.infos).to include(Blabbermouth::Gawkers::Rails.new.send(:log_message, :time, 'key', 1))
    end
  end
end
