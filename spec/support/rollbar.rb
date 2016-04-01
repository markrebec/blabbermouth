class Rollbar
  attr_reader :infos, :errors, :criticals, :warnings, :debugs

  class << self
    def rollbar
      @rollbar ||= new
    end

    def infos
      rollbar.infos
    end

    def errors
      rollbar.errors
    end

    def criticals
      rollbar.criticals
    end

    def warnings
      rollbar.warnings
    end

    def debugs
      rollbar.debugs
    end

    def info(e, data)
      rollbar.info(e, data)
    end

    def error(e, data)
      rollbar.error(e, data)
    end

    def critical(e, data)
      rollbar.critical(e, data)
    end

    def warning(e, data)
      rollbar.warning(e, data)
    end

    def debug(e, data)
      rollbar.debug(e, data)
    end

    def clear!
      rollbar.clear!
    end
  end

  def info(e, data)
    @infos << [e, data]
  end

  def error(e, data)
    @errors << [e, data]
  end

  def critical(e, data)
    @criticals << [e, data]
  end

  def warning(e, data)
    @warnings << [e, data]
  end

  def debug(e, data)
    @debugs << [e, data]
  end

  def clear!
    @infos = []
    @errors = []
    @criticals = []
    @warnings = []
    @debugs = []
  end

  protected

  def initialize
    clear!
  end
end
