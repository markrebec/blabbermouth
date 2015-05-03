class Rails
  class Logger
    attr_reader :infos, :errors

    def info(msg)
      @infos << msg
    end

    def error(msg)
      @errors << msg
    end

    def clear!
      @infos = []
      @errors = []
    end

    protected

    def initialize
      clear!
    end
  end

  def self.logger
    @logger ||= Rails::Logger.new
  end
end
