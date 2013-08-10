# coding: utf-8
require 'itunes/version'
require 'itunes/application'

module Itunes
  include Application

  defined_methods = Application.instance_methods
  Application.included_modules.each do |included_module|
    defined_methods -= included_module.instance_methods
  end
  module_function *defined_methods
end
