module Blabbermouth
  class Blabber
    attr_reader :gawkers

    class << self
      def error(key, e, *gawkers, data: {})
        new(*gawkers).error(key, e, data: data)
      end

      def info(key, msg=nil, *gawkers, data: {})
        new(*gawkers).info(key, msg, data: data)
      end

      def increment(key, by, *gawkers, data: {})
        new(*gawkers).increment(key, by, data: data)
      end

      def count(key, total, *gawkers, data: {})
        new(*gawkers).count(key, total, data: data)
      end

      def time(key, duration=nil, *gawkers, data: {}, &block)
        new(*gawkers).time(key, duration, data: data, &block)
      end
    end

    def add_gawker!(gawker)
      @gawkers ||= []
      unless gawker_exists?(gawker)
        @gawkers << "Blabbermouth::Gawkers::#{gawker.to_s.camelize}".constantize.new
      end
      @gawkers
    end

    def add_gawker(gawker)
      add_gawker! gawker
    rescue => e
      false
    end

    def remove_gawker!(gawker)
      return if @gawkers.nil?
      @gawkers.slice!(gawker_index(gawker), 1)
    end

    def remove_gawker(gawker)
      remove_gawker! gawker
    rescue => e
      false
    end

    # TODO maybe use method_missing for these to allow passing through
    # custom methods to your custom gawkers
    def error(key, e, *args, data: {})
      gawkers.each { |gawker| gawker.error key, e, *args, data: data }
    end

    def info(key, msg=nil, *args, data: {})
      gawkers.each { |gawker| gawker.info key, msg, *args, data: data }
    end

    def increment(key, by, *args, data: {})
      gawkers.each { |gawker| gawker.increment key, by, *args, data: data }
    end

    def count(key, total, *args, data: {})
      gawkers.each { |gawker| gawker.count key, total, *args, data: data }
    end

    def time(key, duration=nil, *args, data: {}, &block)
      # TODO time the block if it exists and duration is not provided
      gawkers.each { |gawker| gawker.time key, duration, *args, data: data }
    end

    protected

    def initialize(*gawks)
      gawks.each { |gawker| add_gawker gawker }
    end

    def gawker_index(gawker)
      @gawkers.index { |gawk| gawk.class.name.demodulize.underscore == gawker.to_s }
    end

    def gawker_exists?(gawker)
      !gawker_index(gawker).nil?
    end
  end
end
