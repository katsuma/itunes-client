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
      :track_number,
      :year,
      :season_number,
      :episode_number,
      :show,
      :video_kind
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
      Track.find_by(persistent_id: converted_persistent_id).first
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
      Itunes::Player.pause
      self
    end

    def stop
      Itunes::Player.stop
      self
    end

    def update(attributes)
      raise ArgumentError.new('Invalid argument is given') unless attributes.is_a?(Hash)

      records = update_attribute_records(attributes)
      update_targets = { persistent_id: self.persistent_id, update_records: records }
      script_name = generate_script_from_template('track/updater.tmpl.scpt', update_targets)
      execute_template_based_script(script_name)
      attributes.each { |key, val| send("#{key}=", val) }
      self
    end
    alias_method :update_attributes, :update

    def assign_attributes_by(track_attributes)
      ATTRIBUTES.each { |attr| send("#{attr}=", track_attributes[attr.to_s]) }
    end

    def self.find_by(arg)
      raise ArgumentError.new('nil argument is given') if arg.nil?

      if arg.is_a?(Hash)
        conditions = find_conditions(arg)
        whose = 'whose'
      elsif arg == :all
        conditions = ''
        whose = ''
      else
        raise ArgumentError.new('unsupported rgument is given')
      end

      script_name = generate_script_from_template('track/finder.tmpl.scpt', whose: whose, conditions: conditions)
      track_response = execute_template_based_script(script_name)

      tracks_attributes = ::JSON.parse(track_response)
      tracks_attributes.compact.map do |track_attributes|
        Track.new.tap do |track|
          track.assign_attributes_by(track_attributes)
        end
      end
    end

    def self.all
      find_by(:all)
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

    private

    def update_attribute_records(args)
      records = []
      args.each do |key, val|
        if ATTRIBUTES.include?(key)
          if key == :video_kind
            records << "set video kind of specified_track to #{val}"
          else
            records << "set #{key.to_s.gsub('_', ' ')} of specified_track to \"#{val}\""
          end
        end
      end
      records.join("\n")
    end
  end
end
