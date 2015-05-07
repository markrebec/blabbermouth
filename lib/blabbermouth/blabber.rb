module Blabbermouth
  class Blabber
    attr_reader :bystanders, :options

    class << self
      def parse_args(*args)
        opts = args.extract_options!
        args = Blabbermouth.configuration.bystanders if args.empty?
        bystanders = args + [opts.slice!(:data)]
        [bystanders, opts]
      end

      def error(key, e, *args)
        bystanders, opts = parse_args(*args)
        new(*bystanders).error(key, e, opts)
      end

      def info(key, msg=nil, *args)
        bystanders, opts = parse_args(*args)
        new(*bystanders).info(key, msg, opts)
      end

      def increment(key, by=1, *args)
        bystanders, opts = parse_args(*args)
        new(*bystanders).increment(key, by, opts)
      end

      def count(key, total, *args)
        bystanders, opts = parse_args(*args)
        new(*bystanders).count(key, total, opts)
      end

      def time(key, duration=nil, *args, &block)
        bystanders, opts = parse_args(*args)
        new(*bystanders).time(key, duration, opts, &block)
      end
    end

    def add_bystander!(bystander)
      @bystanders ||= []
      unless bystander_exists?(bystander)
        @bystanders << "Blabbermouth::Bystanders::#{bystander.to_s.camelize}".constantize.new
      end
      @bystanders
    end

    def add_bystander(bystander)
      add_bystander! bystander
    rescue => e
      false
    end

    def remove_bystander!(bystander)
      return if @bystanders.nil?
      @bystanders.slice!(bystander_index(bystander), 1)
    end

    def remove_bystander(bystander)
      remove_bystander! bystander
    rescue => e
      false
    end

    def error(key, e, *args)
      blab :error, key, e, *args
    end

    def info(key, msg=nil, *args)
      blab :info, key, msg, *args
    end

    def increment(key, by=1, *args)
      blab :increment, key, by, *args
    end

    def count(key, total, *args)
      blab :count, key, total, *args
    end

    def time(key, duration=nil, *args, &block)
      raise "Blabbermouth::Blabber#time requires a duration or block" if duration.nil? && !block_given?

      if block_given?
        start_time = ::Time.now
        yielded = yield
        duration = (::Time.now - start_time).to_f
      end

      blab :time, key, duration, *args
    end

    def blab(meth, key, *args, &block)
      opts = args.extract_options!
      bystanders.map do |bystander|
        next unless bystander.respond_to?(meth)
        bystander.send meth, key, *args.concat([bystander_options(bystander, opts)]), &block
      end
    end

    def method_missing(meth, *args, &block)
      blab meth, *args, &block
    end

    def respond_to_missing?(meth, include_private=false)
      bystanders.any? { |bystander| bystander.respond_to?(meth, include_private) }
    end

    protected

    def initialize(*bystdrs)
      @options = bystdrs.extract_options!
      bystdrs.concat(options.keys).uniq
      bystdrs.each { |bystander| add_bystander! bystander }
    end

    def bystander_options(bystander, opts={})
     (@options[bystander.class.name.demodulize.underscore.to_sym] || {}).merge(opts)
    end

    def bystander_index(bystander)
      @bystanders.index { |bystdr| bystdr.class.name.demodulize.underscore == bystander.to_s }
    end

    def bystander_exists?(bystander)
      !bystander_index(bystander).nil?
    end
  end
end
