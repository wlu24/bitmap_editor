require 'bitmap_editor.rb'


RSpec.describe 'BitmapEditor' do
  
  describe 'constructor' do
    editor = BitmapEditor.new
    it 'sets image to nil' do
      expect(editor.image).to be_nil
    end
    it 'sets current_max_row to 0' do
      expect(editor.current_max_row).to eq(0)
    end
    it 'sets current_max_col to 0' do
      expect(editor.current_max_col).to eq(0)
    end
  end
  
  
  describe '#parse_command' do
    editor = BitmapEditor.new
    
    context 'when command not supported' do
      lowercase_commands = ['i 10 10','c','l 10 10 A','v 10 5 9 A','h 5 9 10 A','s','a','b']
      uppercase_unsupported_commands = ['A','B','J','K', 'Y', 'Z']
      unsupported_commands = lowercase_commands + uppercase_unsupported_commands
      
      unsupported_commands.each do |c|
        it 'says "unrecognised command :("' do
          expect { editor.parse_command(c) }.to output("unrecognised command :( : #{c}\n").to_stdout
        end
      end
      
    end
    
    context 'when wrong number of arguments' do
      ['I', 'I 10 10 10', 'C 10', 'L 10 10', 'V 10 10 10', 'H 10 10 10', 'S 10'].each do |c|
        it 'says "wrong number of inputs"' do
          expect { editor.parse_command(c) }.to output("wrong number of arguments: #{c}\n").to_stdout
        end
      end
    end
    
    context 'when wrong type of arguments' do
      create_args = ['I 10 a', 'I a 10']
      single_point_args = ['L 10 10 10', 'L A 10 A', 'L 10 A A']
      vertical_args = ['V 10 5 9 10', 'V A 5 9 A', 'V 10 A 9 A', 'V 10 5 A A']
      horizontal_args = ['H 10 5 9 10', 'H A 5 9 A', 'H 10 A 9 A', 'H 10 5 A A']
      wrong_types_commands = create_args + single_point_args + vertical_args + horizontal_args
      
      wrong_types_commands.each do |c|
        it 'says "wrong type of inputs"' do
          expect { editor.parse_command(c) }.to output("wrong type of arguments: #{c}\n").to_stdout
        end
      end
      
    end
  end
  
  
  
end