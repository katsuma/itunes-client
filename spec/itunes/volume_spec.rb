require 'spec_helper'
require 'itunes-client'

include Itunes

describe Volume do
  let(:level) { an_instance_of(Fixnum) }

  describe '.up' do
    it 'calls up.scpt' do
      expect(Volume).to receive(:execute_script).with('volume/up.scpt', level)
      Volume.up
    end
  end

  describe '.down' do
    it 'calls down.scpt' do
      expect(Volume).to receive(:execute_script).with('volume/down.scpt', level)
      Volume.down
    end
  end

  describe '.mute' do
    it 'calls mute.scpt' do
      expect(Volume).to receive(:execute_script).with('volume/mute.scpt')
      Volume.mute
    end
  end

  describe '.unmute' do
    it 'calls unmute.scpt' do
      expect(Volume).to receive(:execute_script).with('volume/unmute.scpt')
      Volume.unmute
    end
  end

  describe '.value' do
    context 'when iTunes returns volume level' do
      it 'returns current value' do
        allow(Volume).to receive(:execute_script).with('volume/value.scpt').and_return("30")
        expect(Volume.value).to eq(30)
      end
    end
  end

end
