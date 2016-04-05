module Blabbermouth
  class Error < ::StandardError
    def initialize(key, e=nil)
      if e.is_a?(Exception)
        super("#{key}: #{e.class.name}: #{e.message}")
        set_backtrace e.backtrace
      else
        super("#{key}: #{e.to_s}")
        set_backtrace caller
      end
    end
  end
  class Debug < Error; end
  class Warning < Error; end
  class Critical < Error; end

  class Info < ::StandardError
    def initialize(key, msg)
      super("#{key}: #{msg}")
    end
  end
  class Increment < Info; end
  class Count < Info; end
  class Time < Info; end
end
