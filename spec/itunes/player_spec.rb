# coding: utf-8
require 'spec_helper'
require 'itunes-client'

include Itunes

describe Player do
  describe '.add' do
    subject(:add) { Player.add(file_name) }

    let(:file_name) { './foo.wav' }
    let(:new_persistent_id) { 'foo' }

    before do
      FileUtils.rm_f(file_name)
    end

    context 'when existent file is given' do
      before do
        expect(Player).to receive(:execute_script).
          with('player/add.scpt', file_name).and_return(new_persistent_id)
        expect(Track).to receive(:find_by).
          with(persistent_id: new_persistent_id).
          and_return([Track.new(persistent_id: new_persistent_id)])
      end

      it 'returns an array of track instance', fakefs: true do
        File.open(file_name, "w") { |f| f.puts 'sample' }
        expect(add).to be_a(Track)
        expect(add.persistent_id).to eq(new_persistent_id)
      end
    end

    context 'when zero byte file is given' do
      it 'raises an EmptyFileError', fakefs: true do
        File.open(file_name, "w") {}
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
      expect(Player).to receive(:execute_script).with('player/pause.scpt')
      Player.pause
    end
  end

  describe '.stop' do
    it 'calls stop.scpt' do
      expect(Player).to receive(:execute_script).with('player/stop.scpt')
      Player.stop
    end
  end

  describe '.play' do
    it 'calls play.scpt' do
      expect(Player).to receive(:execute_script).with('player/play.scpt')
      Player.play
    end
  end

  describe '.lower_volume'
    it 'calls lower_volume.scpt' do
      expect(Player).to receive(:execute_script).with('player/lower_volume.scpt')
      Player.lower_volume
    end
  end

  describe '.raise_volume'
    it 'calls raise_volume.scpt' do
      expect(Player).to receive(:execute_script).with('player/raise_volume.scpt')
      Player.raise_volume
    end
  end

  describe '.mute_volume'
    it 'calls mute_volume.scpt' do
      expect(Player).to receive(:execute_script).with('player/mute_volume.scpt')
      Player.mute_volume
    end
  end

  describe '.unmute_volume'
    it 'calls unmute_volume.scpt' do
      expect(Player).to receive(:execute_script).with('player/unmute_volume.scpt')
      Player.unmute_volume
    end
  end

  describe '.playing?' do
    subject { Player.playing? }
    context 'when iTunes plays a track' do
      before { expect(Player).to receive(:execute_script).with('player/player_state.scpt').and_return('playing') }
      it { expect(subject).to be_truthy }
    end

    context 'when iTunes stops a track' do
      before { expect(Player).to receive(:execute_script).with('player/player_state.scpt').and_return('stopped') }
      it { expect(subject).to be_falsey }
    end
  end

  describe '.paused?' do
    subject { Player.paused? }
    context 'when iTunes plays a track' do
      before { expect(Player).to receive(:execute_script).with('player/player_state.scpt').and_return('playing') }
      it { expect(subject).to be_falsey }
    end

    context 'when iTunes pauses' do
      before { expect(Player).to receive(:execute_script).with('player/player_state.scpt').and_return('paused') }
      it { expect(subject).to be_truthy }
    end
  end

  describe '.stopped?' do
    subject { Player.stopped? }
    context 'when iTunes plays a track' do
      before { expect(Player).to receive(:execute_script).with('player/player_state.scpt').and_return('playing') }
      it { expect(subject).to be_falsey }
    end

    context 'when iTunes stops a track' do
      before { expect(Player).to receive(:execute_script).with('player/player_state.scpt').and_return('stopped') }
      it { expect(subject).to be_truthy }
    end
  end

  describe '.position' do
    it 'calls position.scpt' do
      expect(Player).to receive(:execute_script).with('player/position.scpt')
      Player.position
    end
  end

  describe '.position=' do
    let(:position) { 10 }

    it 'sets player position by argument' do
      expect(Player).to receive(:execute_script).with('player/set_position.scpt', position)
      Player.position = position
    end
  end

  describe '.next_track' do
    before do
      expect(Player).to receive(:execute_script).
        with('player/next_track.scpt').and_return(new_persistent_id)
      expect(Track).to receive(:find_by).
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
      expect(Player).to receive(:execute_script).
        with('player/prev_track.scpt').and_return(new_persistent_id)
      expect(Track).to receive(:find_by).
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
      expect(Player).to receive(:execute_script).
        with('player/current_track.scpt').
        and_return(new_persistent_id)
      expect(Track).to receive(:find_by).
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
