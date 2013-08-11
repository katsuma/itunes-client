# coding: utf-8
require 'singleton'

require 'itunes/track'
require 'itunes/util'

module Itunes
  class Player
    extend Itunes::Util::Executor

    class << self
      def add(file_path)
        persistent_id = execute_script("#{script_dir}/add.scpt", file_path)
        Track.find_by(persistent_id: persistent_id).first
      end

      def play
        execute_script("#{script_dir}/play.scpt")
        self
      end

      def stop
        execute_script("#{script_dir}/stop.scpt")
        self
      end

      def pause
        execute_script("#{script_dir}/pause.scpt")
        self
      end

      def playing?
        execute_script("#{script_dir}/player_state.scpt") == 'playing'
      end

      def paused?
        execute_script("#{script_dir}/player_state.scpt") == 'paused'
      end

      def stopped?
        execute_script("#{script_dir}/player_state.scpt") == 'stopped'
      end

      def next_track
        persistent_id = execute_script("#{script_dir}/next_track.scpt")
        Track.find_by(persistent_id: persistent_id).first
      end

      def prev_track
        persistent_id = execute_script("#{script_dir}/prev_track.scpt")
        Track.find_by(persistent_id: persistent_id).first
      end

      private
      def script_dir
        'player'
      end
    end
  end
end
