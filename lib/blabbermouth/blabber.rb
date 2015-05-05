module Blabbermouth
  class Blabber
    attr_reader :gawkers, :options

    class << self
      def parse_args(*args)
        opts = args.extract_options!
        args = Blabbermouth.configuration.gawkers if args.empty?
        gawkers = args + [opts.slice!(:data)]
        [gawkers, opts]
      end

      def error(key, e, *args)
        gawkers, opts = parse_args(*args)
        new(*gawkers).error(key, e, opts)
      end

      def info(key, msg=nil, *args)
        gawkers, opts = parse_args(*args)
        new(*gawkers).info(key, msg, opts)
      end

      def increment(key, by=1, *args)
        gawkers, opts = parse_args(*args)
        new(*gawkers).increment(key, by, opts)
      end

      def count(key, total, *args)
        gawkers, opts = parse_args(*args)
        new(*gawkers).count(key, total, opts)
      end

      def time(key, duration=nil, *args, &block)
        gawkers, opts = parse_args(*args)
        new(*gawkers).time(key, duration, opts, &block)
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

    def error(key, e, *args)
      opts = args.extract_options!
      gawkers.map { |gawker| gawker.error key, e, *args.concat([gawker_options(gawker, opts)]) }
    end

    def info(key, msg=nil, *args)
      opts = args.extract_options!
      gawkers.map { |gawker| gawker.info key, msg, *args.concat([gawker_options(gawker, opts)]) }
    end

    def increment(key, by=1, *args)
      opts = args.extract_options!
      gawkers.map { |gawker| gawker.increment key, by, *args.concat([gawker_options(gawker, opts)]) }
    end

    def count(key, total, *args)
      opts = args.extract_options!
      gawkers.map { |gawker| gawker.count key, total, *args.concat([gawker_options(gawker, opts)]) }
    end

    def time(key, duration=nil, *args, &block)
      raise "Blabbermouth::Blabber#time requires a duration or block" if duration.nil? && !block_given?
      opts = args.extract_options!

      if block_given?
        start_time = ::Time.now
        yielded = yield
        duration = (::Time.now - start_time).to_f
      end

      gawkers.map { |gawker| gawker.time key, duration, *args.concat([gawker_options(gawker, opts)]) }
    end

    def method_missing(meth, *args, &block)
      gawkers.map do |gawker|
        next unless gawker.respond_to?(meth)
        gawker.send(meth, *args, &block)
      end
    end

    def respond_to_missing?(meth, include_private=false)
      gawkers.any? { |gawker| gawker.respond_to?(meth, include_private) }
    end

    protected

    def initialize(*gawks)
      @options = gawks.extract_options!
      gawks.concat(options.keys).uniq
      gawks.each { |gawker| add_gawker! gawker }
    end

    def gawker_options(gawker, opts={})
     (@options[gawker.class.name.demodulize.underscore.to_sym] || {}).merge(opts)
    end

    def gawker_index(gawker)
      @gawkers.index { |gawk| gawk.class.name.demodulize.underscore == gawker.to_s }
    end

    def gawker_exists?(gawker)
      !gawker_index(gawker).nil?
    end
  end
end
