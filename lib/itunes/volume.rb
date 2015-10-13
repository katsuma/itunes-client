require 'itunes/util'

module Itunes
  class Volume
    extend Itunes::Util::Executor

    class << self
      def up(level = 10)
        execute_script("#{script_dir}/up.scpt", level)
        self
      end

      def down(level = 10)
        execute_script("#{script_dir}/down.scpt", level)
        self
      end

      def mute
        execute_script("#{script_dir}/mute.scpt")
        self
      end

      def unmute
        execute_script("#{script_dir}/unmute.scpt")
        self
      end

      def value
        execute_script("#{script_dir}/value.scpt")
      end

      private
      def script_dir
        'volume'
      end
    end
  end
end
