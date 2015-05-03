class Rollbar
  attr_reader :infos, :errors

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

    def info(e, data)
      rollbar.info(e, data)
    end

    def error(e, data)
      rollbar.error(e, data)
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

  def clear!
    @infos = []
    @errors = []
  end

  protected

  def initialize
    clear!
  end
end
