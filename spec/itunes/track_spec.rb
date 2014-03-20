# coding: utf-8
require 'spec_helper'
require 'itunes-client'

include Itunes

describe Track do
  let(:track) do
    Track.new(persistent_id: base_persistent_id, name: base_name, album: base_album)
  end
  let(:app) { Itunes }
  let(:base_persistent_id) { 'foo' }
  let(:base_name) { 'base name' }
  let(:base_album) { 'base album' }

  describe '#initialize' do
    subject(:init) { Track.new(args) }

    context 'when nil is given' do
      let(:args) { nil }
      it { expect(init).to be_a(Track) }
    end

    context 'when some attributes are given' do
      let(:args) { { persistent_id: '0123ABC', name: 'clammbon' } }
      it { expect(init).to be_a(Track) }
    end
  end

  describe '#convert' do
    subject(:convert) { track.convert }
    let(:new_persistent_id) { 'bar' }

    before do
      track.should_receive(:execute_script).
        with('track/convert.scpt', base_persistent_id).
        and_return(new_persistent_id)
      Track.should_receive(:find_by).
        with(persistent_id: new_persistent_id).
        and_return([Track.new(persistent_id: new_persistent_id)])
    end

    it 'returns a new Track' do
      converted_track = convert
      expect(converted_track).to be_a(Track)
      expect(converted_track.persistent_id).to eq(new_persistent_id)
    end
  end

  describe '#delete!' do
    subject { track.delete! }

    before do
      track.should_receive(:execute_script).
        with('track/delete.scpt', track.persistent_id)
    end

    it { expect(subject).to be_nil }
  end

  describe '#play' do
    subject { track.play }

    before do
      track.should_receive(:execute_script).
        with('track/play.scpt', track.persistent_id)
    end

    it { expect(subject).to be_eql(track) }
  end

  describe '#pause' do
    subject(:pause) { track.pause }

    it 'calls application#pause' do
      app.should_receive(:pause)
      pause
    end
  end

  describe '#stop' do
    subject(:stop) { track.stop }

    it 'calls application#stop' do
      app.should_receive(:stop)
      stop
    end
   end

  describe '#update' do
    subject(:update) { track.update(attributes) }

    context 'when nil argument is given' do
      let(:attributes) { nil }
      it 'raises an ArgumentError' do
        expect { update }.to raise_error(ArgumentError)
      end
    end

    context 'when hash argument is given' do
      let(:new_scpt)   { 'new.scpt' }
      let(:new_name)   { 'new name' }
      let(:new_album)  { 'new album' }
      let(:attributes) { { name: new_name, album: new_album } }

      before do
        track.stub(:generate_script_from_template).
          with('track/updater.tmpl.scpt', persistent_id: track.persistent_id, update_records: "set name of specified_track to \"#{new_name}\"\nset album of specified_track to \"#{new_album}\"").
          and_return(new_scpt)
        track.stub(:execute_template_based_script).
          with(new_scpt)
      end

      it 'updates given attributes' do
        update
        expect(track.name).to be_eql(new_name)
        expect(track.album).to be_eql(new_album)
      end

      it 'does not update persistent_id' do
        expect { update }.not_to change { track.persistent_id }.from(base_persistent_id)
      end
    end
  end

  describe '.find_by' do
    subject(:find) { Track.find_by(arg) }
    let(:finder_scpt) { 'track/finder.tmpl.scpt' }

    context 'when nil argument is given' do
      let(:arg) { nil }
      it 'raises an ArgumentError' do
        expect { find }.to raise_error(ArgumentError)
      end
    end

    context 'when unsupported symbol is given' do
      let(:arg) { :first }
      it 'raises an ArgumentError' do
        expect { find }.to raise_error(ArgumentError)
      end
    end

    context 'when hash argument is given' do
      let(:arg) { { name: name } }
      let(:new_scpt) { 'new.scpt' }
      let(:new_persistent_id) { 'bar' }
      let(:name) { 'Hey Jude' }

      before do
        Track.stub(:generate_script_from_template).
          and_return(new_scpt)

        Track.stub(:execute_template_based_script).
          and_return([{ persistent_id: new_persistent_id, name: name }].to_json)
      end

      it 'returns an array of track with specified name' do
        tracks = find
        expect(tracks.size).to eq(1)
        expect(tracks.first.name).to eq(name)
      end
    end
  end

  describe '.all' do
    subject(:all) { Track.all }

    it 'calls find_by(:all)' do
      Track.stub(:generate_script_from_template).
        and_return('new.scpt')

      Track.stub(:execute_template_based_script).
        with('new.scpt').
        and_return([].to_json)

      all
    end
  end
end
