# coding: utf-8
require 'spec_helper'
require 'itunes-client'

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

    before { FileUtils::touch(script_full_path) }

    it 'retuens a script result' do
      Open3.should_receive(:capture2).with("osascript #{script_full_path}").and_return(result)
      expect(execute_template_based_script).to eq(result)
    end

    it 'deletes a generated script' do
      expect { execute_template_based_script }.to change {
        File.exist?(script_full_path)
      }.from(true).to(false)
    end

  end

end
