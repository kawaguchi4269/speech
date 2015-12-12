require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'optparse'
require 'pathname'
require 'logger'
require 'date'
require 'yaml'
require 'erb'
module App
  def self.root
    Pathname File.expand_path '../..', __FILE__
  end

  def self.logger
    @logger ||= Logger.new STDERR
  end
end

opt = OptionParser.new
@option = {}
opt.on('-c', 'checks test, timer, mic and last') { @option[:checkup] = true }
opt.parse!(ARGV)

dbconfig = YAML.load File.read 'config/database.yml'
ActiveRecord::Base.establish_connection(dbconfig)
ActiveRecord::Base.logger = Logger.new(STDERR)
# Time.zone_default =  Time.find_zone! 'Tokyo' # config.time_zone
Dir.glob("#{App.root}/models/*.rb").each { |f| require f }

if $DEBUG
  require 'timecop'
  Timecop.scale(4 * 60**2)

  set_trace_func proc { |event, _file, _line, id, _binding, classname|
    # only interested in events of type 'call' (Ruby method calls)
    # see the docs for set_trace_func for other supported event types
    App.logger.debug "#{classname}##{id} called" if event == 'call'
  }
end
