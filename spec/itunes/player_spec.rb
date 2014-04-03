# coding: utf-8
require 'spec_helper'
require 'itunes-client'

include Itunes

describe Player do
  describe '.add' do
    subject(:add) { Player.add(file_name) }

    let(:file_name) { '/tmp/foo.wav' }
    let(:new_persistent_id) { 'foo' }

    before do
      FileUtils.rm_f(file_name)
    end

    context 'when existent file is given' do
      before do
        `echo "foo" > #{file_name}`
      end

      before do
        Player.should_receive(:execute_script).
          with('player/add.scpt', file_name).and_return(new_persistent_id)
        Track.should_receive(:find_by).
          with(persistent_id: new_persistent_id).
          and_return([Track.new(persistent_id: new_persistent_id)])
      end

      it 'returns an array of track instance', fakefs: true do
        expect(add).to be_a(Track)
        expect(add.persistent_id).to eq(new_persistent_id)
      end
    end

    context 'when zero byte file is given' do
      before do
        FileUtils.touch(file_name)
      end

      it 'raises an EmptyFileError', fakefs: true do
        expect { add }.to raise_error(Itunes::Player::EmptyFileError)
      end
    end

    context 'when non existent file is given' do
      it 'raises a FileNotFoundrror', fakefs: true do
        expect { add }.to raise_error(Itunes::Player::FileNotFoundError)
      end
    end
  end

  describe '.pause' do
    it 'calls pause.scpt' do
      Player.should_receive(:execute_script).with('player/pause.scpt')
      Player.pause
    end
  end

  describe '.stop' do
    it 'calls stop.scpt' do
      Player.should_receive(:execute_script).with('player/stop.scpt')
      Player.stop
    end
  end

  describe '.play' do
    it 'calls play.scpt' do
      Player.should_receive(:execute_script).with('player/play.scpt')
      Player.play
    end
  end

  describe '.playing?' do
    subject { Player.playing? }
    context 'when iTunes plays a track' do
      before { Player.should_receive(:execute_script).with('player/player_state.scpt').and_return('playing') }
      it { expect(subject).to be_true }
    end

    context 'when iTunes stops a track' do
      before { Player.should_receive(:execute_script).with('player/player_state.scpt').and_return('stopped') }
      it { expect(subject).to be_false }
    end
  end

  describe '.paused?' do
    subject { Player.paused? }
    context 'when iTunes plays a track' do
      before { Player.should_receive(:execute_script).with('player/player_state.scpt').and_return('playing') }
      it { expect(subject).to be_false }
    end

    context 'when iTunes pauses' do
      before { Player.should_receive(:execute_script).with('player/player_state.scpt').and_return('paused') }
      it { expect(subject).to be_true }
    end
  end

  describe '.stopped?' do
    subject { Player.stopped? }
    context 'when iTunes plays a track' do
      before { Player.should_receive(:execute_script).with('player/player_state.scpt').and_return('playing') }
      it { expect(subject).to be_false }
    end

    context 'when iTunes stops a track' do
      before { Player.should_receive(:execute_script).with('player/player_state.scpt').and_return('stopped') }
      it { expect(subject).to be_true }
    end
  end

  describe '.next_track' do
    before do
      Player.should_receive(:execute_script).
        with('player/next_track.scpt').and_return(new_persistent_id)
      Track.should_receive(:find_by).
        with(persistent_id: new_persistent_id).
        and_return([Track.new(persistent_id: new_persistent_id)])
    end
    let(:new_persistent_id) { 'foo' }

    it 'plays a next track' do
      next_track = Player.next_track
      expect(next_track.persistent_id).to eq(new_persistent_id)
    end
  end

  describe '.prev_track' do
    before do
      Player.should_receive(:execute_script).
        with('player/prev_track.scpt').and_return(new_persistent_id)
      Track.should_receive(:find_by).
        with(persistent_id: new_persistent_id).
        and_return([Track.new(persistent_id: new_persistent_id)])
    end
    let(:new_persistent_id) { 'foo' }

    it 'plays a previous track' do
      next_track = Player.prev_track
      expect(next_track.persistent_id).to eq(new_persistent_id)
    end
  end

  describe '.current_track' do
    before do
      Player.should_receive(:execute_script).
        with('player/current_track.scpt').
        and_return(new_persistent_id)
      Track.should_receive(:find_by).
        with({ persistent_id: new_persistent_id }).
        and_return([Track.new(persistent_id: new_persistent_id)])
    end
    let(:new_persistent_id) { 'new_persistent_id' }

    it 'returns a current track' do
      current_track = Player.current_track
      expect(current_track.persistent_id).to eq(new_persistent_id)
    end
  end

end
