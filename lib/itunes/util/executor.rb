# coding: utf-8
module Itunes
  module Util
    module Executor
      def generate_script_from_template(template_path, args)
        body = ''
        script_name = "#{Time.now.to_i}.#{rand(1000)}.scpt"
        script_path = "#{script_tmp_dir}/#{script_name}"

        open("#{script_base_dir}/#{template_path}", 'r') do |f|
          f.each { |line| body << line }
        end

        args.each do |key, val|
          body.gsub!("#\{#{key}\}", val)
        end

        open(script_path, 'w') do |f|
          f.write(body)
        end

        script_name
      end

      def execute_script(script_path, args='')
        execute_out, process_status = *Open3.capture2("osascript #{script_base_dir}/#{script_path} #{args}")
        execute_out.chomp
      end

      def execute_template_based_script(script_path)
        execute_out, process_status = *Open3.capture2("osascript #{script_tmp_dir}/#{script_path}")
        ::FileUtils.rm "#{script_tmp_dir}/#{script_path}"
        execute_out.chomp
      end

      def script_base_dir
        File.expand_path("#{File.dirname(__FILE__)}/../../../scripts")
      end

      def script_tmp_dir
        Dir.tmpdir
      end
    end
  end
end
