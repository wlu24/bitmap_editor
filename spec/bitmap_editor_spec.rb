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
  
  
  

  describe '#integer?' do
    context 'when the string argument does not represents an integer' do
      ['abc','a23', '12a', '1a3', ''].each do |s|
        it 'returns false' do
          expect( BitmapEditor.integer?(s) ).to be false
        end
      end
    end
    
    context 'when the string argument represents an integer' do
      ['123','012','120', '1', '-1', '-123'].each do |s|
        it 'returns true' do
          expect( BitmapEditor.integer?(s) ).to be true
        end
      end
    end
  end
  
  describe '#valid_color?' do 
    context 'when argument is valid' do
      ('A'..'Z').each do |c|
        it 'returns true' do
          expect(BitmapEditor.valid_color?(c) ).to be true
        end
      end
    end
    
    context 'when argument is invalid' do
      ['a', 'aA', 'Aa', 'AA', '1', '123', 'blue', ''].each do |c|
        it 'returns false' do 
          expect(BitmapEditor.valid_color?(c) ).to be false
        end
      end
    end
  end
  
  
  def is_all_white_pixels?(editor)
    # check if every pixel is set to white (O)
    is_all_white_pixels = true
    @editor.image.each do |row|
      break if !is_all_white_pixels
      
      row.each do |pixel|
        if pixel != "O"
          is_all_white_pixels = false
          break
        end
      end
    end
    
    return is_all_white_pixels
  end
  
  
  describe '#process_create_command' do
    context "when arguments are within bounds" do
      before(:each)  { @editor = BitmapEditor.new }
      in_bounds_commands = [[1,1],[10,20],[50,50],[250,250], [250,1], [1,250]]
      in_bounds_commands.each do |col,row|
        it "creates an image of size where column = #{col} and row = #{row} with all pixels colored white (O)" do
          @editor.process_create_command(col,row)
          
          expect(@editor.current_max_col).to eq(col)
          expect(@editor.current_max_row).to eq(row)
          
          expect(@editor.image.length).to eq(row)
          expect(@editor.image[0].length).to eq(col)
          
          expect(is_all_white_pixels?(@editor)).to be true
          
        end
      end
    end
    
    context "when arguments are out of bounds" do
      before(:each)  { @editor = BitmapEditor.new }
      out_of_bounds_commands = [[0,0],[251,251], [251,1], [1,251], [0,250], [250,0]]
      out_of_bounds_commands.each do |col,row|
        it "does not create an image and say 'create image failed: input(s) out of bound'" do
          err_msg = "create image failed: I #{col} #{row}" 
          err_msg += "     (inputs out of bound; column size must be between 1 and #{BitmapEditor.max_col},"
          err_msg += " row size must be between 1 and #{BitmapEditor.max_row})\n"
          expect {@editor.process_create_command(col,row) }.to output(err_msg).to_stdout
        end
      end
    end
  end
  
  
  
  describe '#process_point_command' do
    context "when image not yet created" do
      it 'says "there is no image"' do
        @editor = BitmapEditor.new
        expect {@editor.process_point_command(1,1, "O") }.to output("there is no image\n").to_stdout
      end
    end
    
    before(:each) do
      @editor = BitmapEditor.new
      @editor.process_create_command(8,8)
    end
    
    context "when inputs are out of bounds" do
      [[0,0,'A'], [0,1,'A'], [1,0,'A'], [8,9,'A'], [9,8,'A'], [9,9, 'A']].each do |col, row, color|
        it "says 'command failed'" do
          err_msg = "command failed: L #{col} #{row} #{color}"
          err_msg += "     (input out of bound; max col is #{@editor.current_max_col}, max row is #{@editor.current_max_row})\n"
          expect { @editor.process_point_command(col, row, color) }.to output(err_msg).to_stdout
        end
      end
    end
    
    context "when inputs are valid" do
      [[1,1,'A'], [8,8,'B'], [2,4,'C'], [7,3,'D']].each do |col, row, color|
        it 'sets the point to the given color' do
          @editor.process_point_command(col,row,color)
          expect( @editor.image[col - 1][row - 1]).to eq(color)   # col - 1 and row - 1 because arrays are zero indexed
        end
      end
    end
    
  end
  
  
  describe '#process_vertical_line_command' do
    context "when image not yet created" do
      it 'says "there is no image"' do
        @editor = BitmapEditor.new
        expect {@editor.process_vertical_line_command(1,1,2,"O") }.to output("there is no image\n").to_stdout
      end
    end
    
    before(:each) do
      @editor = BitmapEditor.new
      @editor.process_create_command(8,8)
    end
    
    context "when column input are out of bounds" do
      it 'says "command failed"' do
        expect {@editor.process_vertical_line_command(0,1,2,"A") }.to output("command failed: V 0 1 2 A     (column input out of bounds)\n").to_stdout
        expect {@editor.process_vertical_line_command(9,1,2,"O") }.to output("command failed: V 9 1 2 O     (column input out of bounds)\n").to_stdout
      end
    end
    
    context "when row inputs are out of bounds" do
      [[1,0,1,'A'],[1,1,9,'A'],[1,0,9,'A']].each do |col, row_start, row_end, color|
        it 'says "command failed"' do
          err_msg = "command failed: V #{col} #{row_start} #{row_end} #{color}     (row input out of bounds)\n"
          expect {@editor.process_vertical_line_command(col,row_start,row_end, color) }.to output(err_msg).to_stdout
        end
      end
    end
    
    context "when inputs are valid" do
      it 'set color correctly with input 1,1,5,A' do
        @editor.process_vertical_line_command(1, 1, 5,'A')
        
        # set_correctly = true
        # 0.upto(4) {|i| set_correctly &&= (@editor.image[0][i] == 'A' )}
        # expect(set_correctly).to be true
        expect(@editor.image[0][0]).to eq('A')
        expect(@editor.image[0][1]).to eq('A')
        expect(@editor.image[0][2]).to eq('A')
        expect(@editor.image[0][3]).to eq('A')
        expect(@editor.image[0][4]).to eq('A')
      end
      
      it 'set color correctly with input 8,8,6,B' do
        @editor.process_vertical_line_command(8,8,6,'B')
        set_correctly = true
        5.upto(7) {|i| set_correctly &&= (@editor.image[7][i] == 'B') }
        expect(set_correctly).to be true
      end
      
      it 'set color correctly with input 3,3,3,C' do
        @editor.process_vertical_line_command(3,3,3,'C')
        expect(@editor.image[2][2]).to eq('C')
        
      end
      
      
      
      
    end
  end
  
  describe '#process_horizontal_line_command' do
    context "when image not yet created" do
      it 'says "there is no image"' do
        @editor = BitmapEditor.new
        expect {@editor.process_horizontal_line_command(1,2,1,"O") }.to output("there is no image\n").to_stdout
      end
    end
    
    before(:each) do
      @editor = BitmapEditor.new
      @editor.process_create_command(8,8)
    end
    
    context "when column inputs are out of bounds" do
      [[0,1,1,'A'],[1,9,1,'A'],[0,9,1,'A']].each do |col_start, col_end, row, color|
        it 'says "command failed"' do
          err_msg = "command failed: H #{col_start} #{col_end} #{row} #{color}     (column input out of bounds)\n"
          expect {@editor.process_horizontal_line_command(col_start,col_end,row, color) }.to output(err_msg).to_stdout
        end
      end
    end
    
    context "when row input is out of bounds" do
      it 'says "command fail"' do
        expect {@editor.process_horizontal_line_command(1,2,0,"A") }.to output("command failed: H 1 2 0 A     (row input out of bounds)\n").to_stdout
        expect {@editor.process_horizontal_line_command(1,2,9,"O") }.to output("command failed: H 1 2 9 O     (row input out of bounds)\n").to_stdout
      end
    end
    
    context "when inputs are valid" do
      it 'set color correctly with input 1,5,1,A' do
        @editor.process_horizontal_line_command(1,5,1,'A')
        
        set_correctly = true
        0.upto(4) {|i| set_correctly &&= (@editor.image[i][0] == 'A' )}
        expect(set_correctly).to be true
      end
      
      it 'set color correctly with input 8,6,8,B' do
        @editor.process_horizontal_line_command(8,6,8,'B')
        
        set_correctly = true
        5.upto(7) {|i| set_correctly &&= (@editor.image[i][7] == 'B' )}
        expect(set_correctly).to be true
      end
      
      it 'set color correctly with input 3,3,3,C' do
        @editor.process_horizontal_line_command(3,3,3,'C')
        expect(@editor.image[2][2]).to eq('C')
      end
    end
  end
  
    
  

  
end