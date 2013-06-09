# coding: utf-8
require 'spec_helper'
require 'itunes-client'

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
    let(:new_persistent_id) { 'foo' }

    before do
      app.should_receive(:execute_script).
        with('application/add.scpt', file_name).and_return(new_persistent_id)
      Track.should_receive(:find_by).
        with(persistent_id: new_persistent_id).
        and_return(Track.new(persistent_id: new_persistent_id))
    end

    it 'returns a track instance' do
      track = add

      expect(track).to be_a(Track)
      expect(track.persistent_id).to eq(new_persistent_id)
    end
  end

  describe '#pause' do
    it 'calls pause.scpt' do
      app.should_receive(:execute_script).with('application/pause.scpt')
      app.pause
    end
  end

  describe '#stop' do
    it 'calls stop.scpt' do
      app.should_receive(:execute_script).with('application/stop.scpt')
      app.stop
    end
  end
end
