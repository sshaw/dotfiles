require "irb/completion"
require "irb/ext/save-history"
require "pp"
require "rubygems"

IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 10_000
IRB.conf[:AUTO_INDENT] = true
IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_I => "#{"j" if RUBY_PLATFORM=="java"}irb [#{RUBY_VERSION}]$ ",
  :PROMPT_C => "%i* ",
  :PROMPT_N => "%i{ ",
  :PROMPT_S => "%i%l ",
  :RETURN   => "=> %s\n"
}

custom = IRB.conf[:PROMPT][:CUSTOM]
if defined?(Rails)
  custom[:PROMPT_I] = "rails [#{Rails.version}]$ "
elsif defined?(Padrino)
  custom[:PROMPT_I] = "padrino [#{Padrino.version}]$ "
end

IRB.conf[:PROMPT_MODE] = :CUSTOM

if defined?(ActiveRecord)
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

def q!; quit; end
