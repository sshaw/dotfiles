require "irb/completion"
require "rubygems"

#IRB.conf[:USE_READLINE] = true
IRB.conf[:SAVE_HISTORY] = 10_000
IRB.conf[:PROMPT][:CUSTOM] = {
  :PROMPT_I => "irb (#{RUBY_VERSION})> ",
  :PROMPT_C => "%i* ",
  :PROMPT_N => "%i{ ",
  :PROMPT_S => "%i%l ",
  :RETURN   => "=> %s\n"
}

IRB.conf[:PROMPT_MODE] = :CUSTOM
