# coding: utf-8
require 'spec_helper'
require 'itunes/util'

describe Itunes::Util::Executor do
  class DummyClass
    include Itunes::Util::Executor
  end
  let!(:klass) { DummyClass.new }

  describe '#execute_script' do
    subject(:execute_script) { klass.execute_script(path, args) }

    let(:path) { 'foo.scpt' }
    let(:args) { 'bar' }
    let(:result) { { status: 'ok' }.to_json }

    it 'returns a script result' do
      Open3.should_receive(:capture2).with("osascript #{klass.script_base_dir}/#{path} #{args}").and_return(result)
      expect(execute_script).to eq(result)
    end
  end

  describe '#execute_template_based_script' do
    subject(:execute_template_based_script) { klass.execute_template_based_script(path) }

    let(:path) { 'foo.scpt' }
    let(:script_full_path) { "#{klass.script_tmp_dir}/#{path}" }
    let(:result) { { status: 'ok' }.to_json }

    before do
      Open3.should_receive(:capture2).with("osascript #{script_full_path}").and_return(result)
      FileUtils.touch(script_full_path)
    end

    it 'retuens a script result' do
      expect(execute_template_based_script).to eq(result)
    end

    it 'deletes a generated script' do
      expect { execute_template_based_script }.to change {
        File.exist?(script_full_path)
      }.from(true).to(false)
    end
  end

  describe '#generate_script_from_template' do
    subject(:generate_script_from_template) { klass.generate_script_from_template(path, args) }

    let(:path) { 'spec.scpt' }
    let(:args) { { target: 'bar' } }

    before do
      script_path = "#{klass.script_base_dir}/#{path}"
      open(script_path, 'w') { |f| f.write('#{target}') }
    end

    after do
      FileUtils.rm("#{klass.script_base_dir}/#{path}")
    end
    it 'returns script path which replaces template key' do
      script_path = generate_script_from_template
      body = ''
      open("#{klass.script_tmp_dir}/#{script_path}", 'r') do |f|
        f.each { |line| body << line }
      end
      expect(body).to eq('bar')
    end
  end
end
