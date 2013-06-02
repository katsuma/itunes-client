# coding: utf-8
module Itunes
  module Util
    module Executor
      def execute_script(script_path, args='')
        execute_out, process_status = *Open3.capture2("osascript #{script_base_dir}/#{script_path} #{args}")
        execute_out
      end

      def script_base_dir
        File.expand_path("#{File.dirname(__FILE__)}/../../../scripts")
      end
    end
  end
end
