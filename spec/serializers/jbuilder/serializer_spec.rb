require 'spec_helper'

RSpec.describe Jbuilder::Serializer do
  subject(:serializer) { serializer_class.new }

  let(:serializer_class) { Class.new described_class }
  let(:renderer) { serializer.send :renderer }

  before do
    allow(serializer_class).to receive(:name).and_return 'SampleSerializer'
  end

  describe '.set_template_path' do
    let(:template_path) { 'name' }

    it 'sets template_path for instances' do
      serializer_class.set_template_path template_path

      expect(serializer_class.new.template_path).to eq template_path
    end
  end

  describe '.locals' do
    context 'when no block is given' do
      it 'raises error' do
        expect {
          serializer_class.locals
        }.to raise_error ArgumentError, /no block given/
      end
    end

    context 'when a block is given' do
      before { serializer_class.locals { 1 } }

      it 'assigns it into @locals_block for later evaluation' do
        expect(serializer_class.locals_block).to be_a Proc
      end
    end
  end

  describe '#initialize' do
    before do
      serializer_class.locals do
        @name = 'Daenerys Targaryen'
        @polemicos = 'name'
      end
    end

    it 'executes locals block on renderer context' do
      expect(renderer.instance_variable_get('@name')).to eq 'Daenerys Targaryen'
      expect(renderer.instance_variable_get('@polemicos')).to eq 'name'
    end
  end

  describe '#to_json' do
    it 'renders jbuilder template as string' do
      expect(renderer).to receive(:render_to_string).with handler: :jbuilder, template: serializer.template_name

      serializer.to_json
    end
  end

  describe '#template_name' do
    it 'returns class name without _serializer suffix' do
      expect(serializer.template_name).to eq 'sample'
    end
  end
end
