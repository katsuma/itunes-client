# coding: utf-8
require 'spec_helper'
require 'itunes-client'

include Itunes

describe Application do
  let(:app) { Itunes }

  describe '#add' do
    subject(:add) { app.add(file_name) }

    let(:file_name) { 'foo.wav' }
    let(:new_persistent_id) { 'foo' }

    before do
      app.should_receive(:execute_script).
        with('application/add.scpt', file_name).and_return(new_persistent_id)
      Track.should_receive(:find_by).
        with(persistent_id: new_persistent_id).
        and_return([Track.new(persistent_id: new_persistent_id)])
    end

    it 'returns an array of track instance' do
      expect(add).to be_a(Track)
      expect(add.persistent_id).to eq(new_persistent_id)
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

  describe '#playing?' do
    subject { app.playing? }
    context 'when iTunes plays a track' do
      before { app.should_receive(:execute_script).with('application/player_state.scpt').and_return('playing') }
      it { expect(subject).to be_true }
    end

    context 'when iTunes stops a track' do
      before { app.should_receive(:execute_script).with('application/player_state.scpt').and_return('stopped') }
      it { expect(subject).to be_false }
    end
  end

  describe '#paused?' do
    subject { app.paused? }
    context 'when iTunes plays a track' do
      before { app.should_receive(:execute_script).with('application/player_state.scpt').and_return('playing') }
      it { expect(subject).to be_false }
    end

    context 'when iTunes pauses' do
      before { app.should_receive(:execute_script).with('application/player_state.scpt').and_return('paused') }
      it { expect(subject).to be_true }
    end
  end

  describe '#stopped?' do
    subject { app.stopped? }
    context 'when iTunes plays a track' do
      before { app.should_receive(:execute_script).with('application/player_state.scpt').and_return('playing') }
      it { expect(subject).to be_false }
    end

    context 'when iTunes stops a track' do
      before { app.should_receive(:execute_script).with('application/player_state.scpt').and_return('stopped') }
      it { expect(subject).to be_true }
    end
  end

end
