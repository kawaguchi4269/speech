require 'rubygems'
require 'bundler'
Bundler.require(:default)

require 'pathname'
require 'logger'
module App
  def self.root
    Pathname File.expand_path '../..', __FILE__
  end

  def self.logger
    @logger ||= Logger.new STDERR
  end
end
