module App
  module Say
    def self.generic(arg)
      return App.logger.debug "[Stub] say #{arg}" if $DEBUG
      `say -v Allison #{arg}`
    end
    def self.timeup
      generic 'time up'
    end
  end
end
