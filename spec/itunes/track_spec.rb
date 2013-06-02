# coding: utf-8
require 'spec_helper'
require 'itunes'

include Itunes

describe Track do
  let(:track) { Track.new(persistent_id: base_persistent_id) }
  let(:base_persistent_id) { 'foo' }

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
        and_return(Track.new(persistent_id: new_persistent_id))
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
    subject { track.pause }

    before do
      track.should_receive(:execute_script).
        with('track/pause.scpt', track.persistent_id)
    end

    it { expect(subject).to be_eql(track) }
  end

  describe '#stop' do
    subject { track.stop }

    before do
      track.should_receive(:execute_script).
        with('track/stop.scpt', track.persistent_id)
    end

    it { expect(subject).to be_eql(track) }
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

    context 'when hash argument which has 1 key is given' do
      let(:arg) { { name: name } }
      let(:new_scpt) { 'new.scpt' }
      let(:new_persistent_id) { 'bar' }
      let(:name) { 'Hey Jude' }

      before do
        Track.stub(:generate_script_from_templae).
          and_return(new_scpt)

        Track.stub(:execute_template_based_script).
          and_return({ persistent_id: new_persistent_id, name: name }.to_json)
      end

      it 'returns a track with specified name' do
        track = find
        expect(track).to be_a(Track)
        expect(track.name).to eq(name)
      end
    end

  end
end
