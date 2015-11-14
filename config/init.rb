require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'optparse'
require 'pathname'
require 'logger'
require 'date'
module App
  def self.root
    Pathname File.expand_path '../..', __FILE__
  end

  def self.logger
    @logger ||= Logger.new STDERR
  end

  def self.settings
    {
      db_name: 'speech.db'
    }
  end
end

opt = OptionParser.new
@option = {}
opt.on('-d TYPE', 'test timer mic last') { |v| @option[:debug] = v }
opt.parse!(ARGV)

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: App.settings[:db_name])
Arel::Table.engine = ActiveRecord::Base

if $DEBUG
  require 'timecop'
  Timecop.scale(4 * 60**2)
end
