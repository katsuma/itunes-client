# coding: utf-8
require 'spec_helper'
require 'itunes'

describe Itunes::Util::Executor do
  class DummyClass
    include Itunes::Util::Executor
  end
  let!(:klass) { DummyClass.new }

  describe '#execute_script' do
    let(:path) { 'foo.scpt' }
    let(:args) { 'bar' }
    let(:result) { 'ok' }
    subject(:execute_script) { klass.execute_script(path, args) }
    it 'returns a script result' do
      Open3.should_receive(:capture2).with("osascript #{klass.script_base_dir}/#{path} #{args}").and_return(result)
      execute_script.should == result
    end
  end
end
