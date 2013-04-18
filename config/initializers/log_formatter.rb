class Logger::SimpleFormatter
  def call(severity, time, progname, msg)
    "#{Time.now} #{severity} #{msg}\n"
  end
end
