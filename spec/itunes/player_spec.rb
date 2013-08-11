# coding: utf-8
require 'spec_helper'
require 'itunes-client'

include Itunes

describe Player do
  let(:player) { Itunes::Player }

  describe '.add' do
    subject(:add) { player.add(file_name) }

    let(:file_name) { 'foo.wav' }
    let(:new_persistent_id) { 'foo' }

    before do
      player.should_receive(:execute_script).
        with('player/add.scpt', file_name).and_return(new_persistent_id)
      Track.should_receive(:find_by).
        with(persistent_id: new_persistent_id).
        and_return([Track.new(persistent_id: new_persistent_id)])
    end

    it 'returns an array of track instance' do
      expect(add).to be_a(Track)
      expect(add.persistent_id).to eq(new_persistent_id)
    end
  end

  describe '.pause' do
    it 'calls pause.scpt' do
      player.should_receive(:execute_script).with('player/pause.scpt')
      player.pause
    end
  end

  describe '.stop' do
    it 'calls stop.scpt' do
      player.should_receive(:execute_script).with('player/stop.scpt')
      player.stop
    end
  end

  describe '.play' do
    it 'calls play.scpt' do
      player.should_receive(:execute_script).with('player/play.scpt')
      player.play
    end
  end

  describe '.playing?' do
    subject { player.playing? }
    context 'when iTunes plays a track' do
      before { player.should_receive(:execute_script).with('player/player_state.scpt').and_return('playing') }
      it { expect(subject).to be_true }
    end

    context 'when iTunes stops a track' do
      before { player.should_receive(:execute_script).with('player/player_state.scpt').and_return('stopped') }
      it { expect(subject).to be_false }
    end
  end

  describe '.paused?' do
    subject { player.paused? }
    context 'when iTunes plays a track' do
      before { player.should_receive(:execute_script).with('player/player_state.scpt').and_return('playing') }
      it { expect(subject).to be_false }
    end

    context 'when iTunes pauses' do
      before { player.should_receive(:execute_script).with('player/player_state.scpt').and_return('paused') }
      it { expect(subject).to be_true }
    end
  end

  describe '.stopped?' do
    subject { player.stopped? }
    context 'when iTunes plays a track' do
      before { player.should_receive(:execute_script).with('player/player_state.scpt').and_return('playing') }
      it { expect(subject).to be_false }
    end

    context 'when iTunes stops a track' do
      before { player.should_receive(:execute_script).with('player/player_state.scpt').and_return('stopped') }
      it { expect(subject).to be_true }
    end
  end

  describe '.next_track' do
    before do
      player.should_receive(:execute_script).
        with('player/next_track.scpt').and_return(new_persistent_id)
      Track.should_receive(:find_by).
        with(persistent_id: new_persistent_id).
        and_return([Track.new(persistent_id: new_persistent_id)])
    end
    let(:new_persistent_id) { 'foo' }

    it 'plays a next track' do
      next_track = player.next_track
      expect(next_track.persistent_id).to eq(new_persistent_id)
    end
  end

  describe '.prev_track' do
    before do
      player.should_receive(:execute_script).
        with('player/prev_track.scpt').and_return(new_persistent_id)
      Track.should_receive(:find_by).
        with(persistent_id: new_persistent_id).
        and_return([Track.new(persistent_id: new_persistent_id)])
    end
    let(:new_persistent_id) { 'foo' }

    it 'plays a previous track' do
      next_track = player.prev_track
      expect(next_track.persistent_id).to eq(new_persistent_id)
    end
  end

end
