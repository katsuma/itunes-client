# coding: utf-8
require 'itunes/version'
require 'itunes/player'

module Itunes
  include Player

  defined_methods = Player.instance_methods
  Player.included_modules.each do |included_module|
    defined_methods -= included_module.instance_methods
  end
  module_function *defined_methods
end
