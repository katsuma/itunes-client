# coding: utf-8
require 'singleton'

require 'itunes/track'
require 'itunes/util'

module Itunes
  class Application
    include Singleton
    include Itunes::Util::Executor

    attr_accessor :tracks

    def add(file_path)
      persistent_id = execute_script("#{script_dir}/add.scpt", file_path)
      Track.new(persistent_id).tap do |track|
        initialize_tracks
        @tracks[persistent_id] = track
      end
    end

    def find(persistent_id)
      initialize_tracks
      @tracks[persistent_id] || Track.new(persistent_id).tap { |t| @tracks[persistent_id] = t }
    end

    private
    def script_dir
      'application'
    end

    def initialize_tracks
      @tracks = {} unless @tracks
    end
  end
end
