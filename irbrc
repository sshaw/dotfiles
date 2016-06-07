begin
  require "bond"
  Bond.start
rescue LoadError
  require "irb/completion"
end

require "pp"
require "rubygems"

def j;  jobs;   end
def q!; quit;   end
def r!; reload! end

def r(lib)
  require lib.to_s
end

def echo!
  conf.echo = !conf.echo
end

def prompt(name, version)
  sprintf "%s [%s] (%s)$ ", name, version, File.basename(Dir.pwd)
end

versions = {
  "jruby"   => "jirb",
  "macruby" => "macirb",
  "rbx"     => "irbx",
  "ree"     => "irbee"
}

target  = Object.const_defined?("RUBY_ENGINE") ? RUBY_ENGINE : RUBY_PLATFORM
irbname = versions.fetch(target,"irb")

IRB.conf[:SAVE_HISTORY] = 10_000
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_I => prompt(irbname, RUBY_VERSION),
  :PROMPT_C => "%i* ",
  :PROMPT_N => "%i{ ",
  :PROMPT_S => "%i%l ",
  :RETURN   => "=> %s\n"
}

# We probably care about irbname here
custom = IRB.conf[:PROMPT][:CUSTOM]
if defined?(Rails)
  custom[:PROMPT_I] = prompt("rails", Rails.version)
elsif defined?(Padrino)
  custom[:PROMPT_I] = prompt("padrino", Padrino.version)
end

IRB.conf[:PROMPT_MODE] = :CUSTOM

if defined?(ActiveRecord) || defined?(Moped)
  require "logger"
  logger = Logger.new(STDERR)

  if defined?(Moped)
    Moped.logger = logger
  else
    begin
      require "hirb"
      extend Hirb::Console
    rescue LoadError
    end

    ActiveRecord::Base.logger = logger

    if File.exists?("NUL") # Too lazy now...
      if defined?(ActiveSupport::LogSubscriber)
        ActiveSupport::LogSubscriber.colorize_logging = false
      else
        ActiveRecord::Base.colorize_logging = false
      end
    end
  end
end
