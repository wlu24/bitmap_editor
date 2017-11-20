require 'command_validator.rb'
require 'bitmap_editor.rb'

RSpec.describe 'CommandValidator' do
  before(:each) { @editor = BitmapEditor.new }

  describe '#integer?' do
    context 'when the string argument does not represents an integer' do
      ['abc', 'a23', '12a', '1a3', ''].each do |s|
        it 'returns false' do
          expect(@editor.integer?(s)).to be false
        end
      end
    end
    context 'when the string argument represents an integer' do
      ['123', '012', '120', '1', '-1', '-123'].each do |s|
        it 'returns true' do
          expect(@editor.integer?(s)).to be true
        end
      end
    end
  end

  describe '#valid_color?' do
    context 'when argument is valid' do
      ('A'..'Z').each do |c|
        it 'returns true' do
          expect(@editor.valid_color?(c)).to be true
        end
      end
    end
    context 'when argument is invalid' do
      ['a', 'aA', 'Aa', 'AA', '1', '123', 'blue', ''].each do |c|
        it 'returns false' do
          expect(@editor.valid_color?(c)).to be false
        end
      end
    end
  end
end
