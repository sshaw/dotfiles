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

# r:some_thang
# r "some/thang"
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
  name = "rails"
  name << "-#{Rails.env}" unless Rails.env.development?

  custom[:PROMPT_I] = prompt(name, Rails.version)
elsif defined?(Padrino)
  name = "padrino"
  name << "-#{ENV["RACK_ENV"]}" unless ENV["RACK_ENV"] == "development"

  custom[:PROMPT_I] = prompt(name, Padrino.version)
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

local = File.join(Dir.pwd, ".irbrc")
load local if local != __FILE__ && File.exists?(local)
