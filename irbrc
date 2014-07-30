require "irb/completion"
require "irb/ext/save-history"
require "pp"
require "rubygems"

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

# Oh MacRuby..!
IRB.conf[:USE_READLINE] = true
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

if defined?(ActiveRecord)
  begin
    require "hirb"
    extend Hirb::Console
  rescue LoadError
  end

  require "logger"
  ActiveRecord::Base.logger = Logger.new(STDERR)

  if File.exists?("NUL") # Too lazy now...
    if defined?(ActiveSupport::LogSubscriber)
      ActiveSupport::LogSubscriber.colorize_logging = false
    else
      ActiveRecord::Base.colorize_logging = false
    end
  end
end

def q!; quit;   end
def r!; reload! end
