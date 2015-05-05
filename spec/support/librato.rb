module Librato
  @increments = {}
  @measurements = {}
  @timings = {}

  def self.increment(key, *args, by: 1)
    @increments[key] ||= 0
    @increments[key] += by
  end

  def self.measure(key, value, *args)
    @measurements[key] ||= []
    @measurements[key] << value
  end

  def self.timing(key, duration, *args)
    @timings[key] ||= []
    @timings[key] << duration
  end

  def self.increments
    @increments
  end

  def self.measurements
    @measurements
  end

  def self.timings
    @timings
  end

  module Metrics
    @annotations = {}

    def self.annotate(key, msg, *args)
      @annotations[key] ||= []
      @annotations[key] << msg
    end

    def self.annotations
      @annotations
    end
  end
end
