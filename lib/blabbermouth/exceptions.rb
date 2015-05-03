module Blabbermouth
  class Error < ::StandardError
    def initialize(key, e)
      super("#{key}: #{e.message}")
      set_backtrace e.backtrace
    end
  end
  class Info < ::StandardError
    def initialize(key, msg)
      super("#{key}: #{msg}")
    end
  end
  class Increment < Info; end
  class Count < Info; end
  class Time < Info; end
end
