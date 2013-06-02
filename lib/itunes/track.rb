# coding: utf-8
require 'json'
require 'itunes/util'

module Itunes
  class Track
    include Itunes::Util::Executor
    extend Itunes::Util::Executor

    ATTRIBUTES = [
      :persistent_id,
      :name,
      :album,
      :artist,
      :track_count,
      :track_number
    ].freeze

    FINDER_ATTRIBUTES = [
      :persistent_id,
      :name,
      :album,
      :artist
    ].freeze

    attr_accessor *ATTRIBUTES

    def initialize(args=nil)
      if args.is_a?(Hash)
        args.each do |attr, val|
          send("#{attr}=", val) if ATTRIBUTES.include?(attr)
        end
      end
    end

    def convert
      converted_persistent_id = execute_script('track/convert.scpt', self.persistent_id)
      Track.find_by(persistent_id: converted_persistent_id)
    end

    def delete!
      execute_script('track/delete.scpt', self.persistent_id)
      nil
    end

    def play
      execute_script('track/play.scpt', self.persistent_id)
      self
    end

    def pause
      execute_script('track/pause.scpt', self.persistent_id)
      self
    end

    def stop
      execute_script('track/stop.scpt', self.persistent_id)
      self
    end

    def assign_attributes_by(itunes_response)
      track_data = ::JSON.parse(itunes_response)
      ATTRIBUTES.each { |attr| send("#{attr}=", track_data[attr.to_s]) }
    end

    def self.find_by(arg)
      raise ArgumentError.new('nil argument is given') if arg.nil?

      conditions = find_conditions(arg)
      script_name = generate_script_from_template('track/finder.tmpl.scpt', conditions: conditions)
      track_response = execute_template_based_script(script_name)

      Track.new.tap do |track|
        track.assign_attributes_by(track_response)
      end
    end

    def self.find_conditions(args)
      conditions = []
      args.each do |key, val|
        if FINDER_ATTRIBUTES.include?(key)
          conditions << "#{key.to_s.gsub('_', ' ')} is \"#{val}\""
        end
      end
      conditions.join(' and ')
    end
    private_class_method :find_conditions

  end
end
