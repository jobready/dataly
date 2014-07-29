require "dataly/version"

require 'logger'
require 'csv'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/object/blank'

module Dataly
  class << self
    attr_accessor :logger
  end
end

require 'dataly/importer'
require 'dataly/mapper'
require 'dataly/creator'
require 'dataly/batch_creator'

Dataly.logger = Logger.new(STDOUT)
Dataly.logger.level = Logger::ERROR