module ExceptionNotification
  class Notifier
    def notify(_error)
      raise NotImplementedError
    end
  end
end
