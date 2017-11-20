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

  describe '#validate' do
    context 'when user input is invalid' do
      # commands not supported
      lowercase_commands = ['i 10 10', 'c', 'l 10 10 A', 'v 10 5 9 A', 'h 5 9 10 A', 's', 'a', 'b']
      uppercase_unsupported_commands = %w[A B J K Y Z]
      not_supported = lowercase_commands + uppercase_unsupported_commands

      # commands with wrong number of arguments
      wrong_nums = ['I', 'I 10 10 10', 'C 10', 'L 10 10', 'V 10 10 10', 'H 10 10 10', 'S 10']

      # commands with wrong type of arguments
      create_args = ['I 10 a', 'I a 10']
      single_point_args = ['L 10 10 10', 'L A 10 A', 'L 10 A A']
      vertical_args = ['V 10 5 9 10', 'V A 5 9 A', 'V 10 A 9 A', 'V 10 5 A A']
      horizontal_args = ['H 10 5 9 10', 'H A 5 9 A', 'H 10 A 9 A', 'H 10 5 A A']
      wrong_types = create_args + single_point_args + vertical_args + horizontal_args

      invalid_commands = not_supported + wrong_nums + wrong_types
      invalid_commands.each do |c|
        it 'raises error' do
          expect { @editor.validate(c) }.to raise_error(ArgumentError)
        end
      end
    end
  end
end
