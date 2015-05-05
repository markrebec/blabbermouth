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

      def increment(key, by=1, *gawkers, data: {})
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

    def error(key, e, *args, data: {})
      gawkers.map { |gawker| gawker.error key, e, *args, data: data }
    end

    def info(key, msg=nil, *args, data: {})
      gawkers.map { |gawker| gawker.info key, msg, *args, data: data }
    end

    def increment(key, by=1, *args, data: {})
      gawkers.map { |gawker| gawker.increment key, by, *args, data: data }
    end

    def count(key, total, *args, data: {})
      gawkers.map { |gawker| gawker.count key, total, *args, data: data }
    end

    def time(key, duration=nil, *args, data: {}, &block)
      raise "Blabbermouth::Blabber.time requires a duration or block" if duration.nil? && !block_given?
      if block_given?
        start_time = ::Time.now
        yielded = yield
        duration = (::Time.now - start_time).to_f
      end

      gawkers.map { |gawker| gawker.time key, duration, *args, data: data }
    end

    def method_missing(meth, *args, &block)
      gawkers.each do |gawker|
        next unless gawker.respond_to?(meth)
        gawker.send(meth, *args, &block)
      end
    end

    def respond_to_missing?(meth, include_private=false)
      gawkers.any? { |gawker| gawker.respond_to?(meth, include_private) }
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
