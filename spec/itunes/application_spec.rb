# coding: utf-8
require 'spec_helper'
require 'itunes'

include Itunes

describe Application do
  let(:app) { described_class.instance }

  describe '#initialize' do
    it 'raises an Error' do
      expect { described_class.new }.to raise_error
    end
  end

  describe '#add' do
    subject(:add) { app.add(file_name) }
    let(:file_name) { 'foo.wav' }
    it 'returns a track instance' do
      app.should_receive(:execute_script).with('application/add.scpt', file_name).and_return('new_persistent_id')
      add.should be_a(Track)
    end
  end

  describe '#find' do
    subject(:find) { app.find(persistent_id) }
    let(:persistent_id) { 'foo' }
    it 'returns a track instance' do
      track = find
      track.should be_a(Track)
      track.persistent_id.should == persistent_id
    end
  end
end
