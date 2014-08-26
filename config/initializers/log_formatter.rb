class ActiveSupport::Logger::SimpleFormatter
  def call(severity, time, progname, msg)
    "#{time.strftime("%Y-%m-%d %H:%M:%S.") << time.usec.to_s[0..2].rjust(3)} [#{severity}] [#{$$}] #{msg}\n"
  end
end
