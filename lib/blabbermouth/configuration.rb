module Blabbermouth
  class Configuration
    DEFAULT_CONFIGURATION_OPTIONS = {
      gawkers: [:stdout]
    }

    attr_reader *DEFAULT_CONFIGURATION_OPTIONS.keys

    DEFAULT_CONFIGURATION_OPTIONS.keys.each do |key|
      define_method "#{key.to_s}=" do |val|
        @changed[key] = [send(key), val]
        instance_variable_set "@#{key.to_s}", val
      end
    end

    def changed
      @changed = {}
      to_hash.each { |key,val| @changed[key] = [@saved_state[key], val] if @saved_state[key] != val }
      @changed
    end

    def changed?(key)
      changed.has_key?(key)
    end

    def configure(args={}, &block)
      save_state
      configure_with_args args
      configure_with_block &block
      self
    end

    def configure_with_args(args)
      args.select { |k,v| DEFAULT_CONFIGURATION_OPTIONS.keys.include?(k) }.each do |key,val|
        instance_variable_set "@#{key.to_s}", val
      end
    end

    def configure_with_block(&block)
      self.instance_eval(&block) if block_given?
    end

    def save_state
      @saved_state = clone.to_hash
      @changed = {}
    end


    def to_hash
      h = {}
      DEFAULT_CONFIGURATION_OPTIONS.keys.each do |key|
        h[key] = instance_variable_get "@#{key.to_s}"
      end
      h
    end
    alias_method :to_h, :to_hash

    protected

    def initialize
      DEFAULT_CONFIGURATION_OPTIONS.each do |key,val|
        instance_variable_set "@#{key.to_s}", val
      end
      save_state
    end
  end
end
