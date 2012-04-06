require "irb/completion"
require "rubygems"


#IRB.conf[:USE_READLINE] = true

IRB.conf[:SAVE_HISTORY] = 10_000
IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_I => "#{"j" if RUBY_PLATFORM=="java"}irb (#{RUBY_VERSION})> ",
  :PROMPT_C => "%i* ",
  :PROMPT_N => "%i{ ",
  :PROMPT_S => "%i%l ",
  :RETURN   => "=> %s\n"
}

if defined? Rails
  IRB.conf[:PROMPT][:CUSTOM][:PROMPT_I] = "rails (#{Rails.version})> "
end

IRB.conf[:PROMPT_MODE] = :CUSTOM
