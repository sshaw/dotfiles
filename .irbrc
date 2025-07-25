require "pp"

begin
  # Completions are in bondrc
  require "bond"
  Bond.start
rescue LoadError
  require "irb/completion"
end

begin
  require "hirb"
  extend Hirb::Console

  def hirb!
    Hirb::View.enabled? ? Hirb.disable : Hirb.enable
  end
rescue LoadError
end

begin
  require "pry-toys"
  # shortcuts for Hash.toy()
  H = Hash
  A = Array
  S = String

  def H.t(*a)
    toy(*a)
  end

  def A.t(*a)
    toy(*a)
  end

  def S.t(*a)
    toy(*a)
  end
rescue LoadError
end

begin
  require "ap"
rescue LoadError
  alias ap pp
end

require "rubygems"

def i(*m) include *m; end
def j;  jobs;   end
def q!; exit;   end
def r!; reload! end
def h; helper; end if defined?(helper)

$E = ENV

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

def cd(path = nil)
  path ||= Dir.home
  path = path == "-" && $__dirstack ? $__dirstack : File.expand_path(path)
  # maybe more $DIRSTACK like one day...
  pwd = Dir.pwd
  Dir.chdir(path)
  $__dirstack = pwd
  path
end

def self.method_missing(name, *args)
  # Commands we don't want to execute
  return super if [:x, :X].freeze.include?(name)

  system name.to_s, *args.map(&:to_s)
  # TODO: Win???
  # Would be nice to echo nothing
  $?.exitstatus == 127 ? super : $?.exitstatus
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

if defined?(Bigcommerce)
  def bigcom(shop)
    config = Bigcommerce::Config.new(:store_hash => shop.platform_id,
                                     :access_token => shop.access_token,
                                     :client_id => ENV['BC_CLIENT_ID'])
    yield Bigcommerce::Connection.build(config)
  end
end

if defined?(ShopifyAPI)
  def shopify(shop, &block)
    if ShopifyAPI::VERSION.split(".")[0].to_i < 9
      ShopifyAPI::Session.temp(shop.shopify_domain, shop.shopify_token, &block)
    else
      ShopifyAPI::Session.temp(:domain => shop.shopify_domain,
                               :token => shop.shopify_token,
                               :api_version => ShopifyAPI::Base.api_version || "2021-01", &block)
    end
  end
end

if defined?(ActiveRecord) || defined?(Moped)
  require "logger"
  logger = Logger.new(STDERR)

  if defined?(Moped)
    Moped.logger = logger
  else
    def connection
      ActiveRecord::Base.connection
    end

    def arerr(model)
      return if model.valid?

      if defined? table
        table(model.errors.full_messages)
      else
        model.errors.full_messages.to_sentence
      end
    end

    class ActiveRecord::Base
      def uc(*a)
        update_column(*a)
      end

      def self.f(*a)
        find(*a)
      end
    end

    ActiveRecord::Base.logger = logger

    if File.exist?("NUL") # Too lazy now...
      if defined?(ActiveSupport::LogSubscriber)
        ActiveSupport::LogSubscriber.colorize_logging = false
      else
        ActiveRecord::Base.colorize_logging = false
      end
    end
  end
end

local = File.join(Dir.pwd, ".irbrc")
load local if local != __FILE__ && File.exist?(local)

local = File.join(Dir.pwd, ".irb-history")
IRB.conf[:HISTORY_FILE] = local if File.exist?(local)

class HistoryInputMethod < IRB::ReadlineInputMethod
  def gets
    l = super

    if ignore_settings.include?("ignoreboth") || ignore_settings.include?("ignorespace")
      HISTORY.pop and return l if HISTORY.size > 0 && HISTORY[-1].start_with?(" ")
    end

    if ignore_settings.include?("ignoreboth") || ignore_settings.include?("ignoredups")
      HISTORY.pop and return l if HISTORY.size > 1 && HISTORY[-1] == HISTORY[-2]
    end

    HISTORY.pop if HISTORY.size > 0 && ignore_patterns.any? { |pat| HISTORY[-1] =~ pat }

    l
  end

  private

  def ignore_patterns
    @ignore_patterns ||= ENV["IRB_HISTIGNORE"].to_s.split(":").map { |pat| Regexp.new(pat) }
  end

  def ignore_settings
    @ignore_settings ||= ENV["IRB_HISTCONTROL"].to_s.split(":")
  end
end

# FIXME: Won't work ruby ruby > 2 :(
if HistoryInputMethod.const_defined?("HISTORY")
  IRB.conf[:SCRIPT] = HistoryInputMethod.new
end
