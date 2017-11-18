require 'bitmap_editor.rb'
require 'helper.rb'

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
          
          expect(Helper.all_white_pixel?(@editor.image)).to be true
          
        end
      end
    end
    
    context "when arguments are out of bounds" do
      before(:each)  { @editor = BitmapEditor.new }
      out_of_bounds_commands = [[0,0],[251,251], [251,1], [1,251], [0,250], [250,0],[1,-1], [-1,1], [-1,-1]]
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
      [[0,0,'A'], [0,1,'A'], [1,0,'A'], [8,9,'A'], [9,8,'A'], [9,9, 'A'], [1,-1,'A'], [-1,1,'A'], [-1,-1,'A']].each do |col, row, color|
        it "says 'command failed'" do
          err_msg = "command failed: L #{col} #{row} #{color}"
          err_msg += "     (input out of bound; X must be between 1 and #{@editor.current_max_col}, Y must be between 1 and #{@editor.current_max_row})\n"
          
          expect { @editor.process_point_command(col, row, color) }.to output(err_msg).to_stdout
        end
      end
    end
    
    context "when inputs are valid" do
      [[1,1,'A'], [8,8,'B'], [2,4,'C'], [7,3,'D']].each do |col, row, color|
        it 'sets the point to the given color' do
          @editor.process_point_command(col,row,color)
          expect( @editor.image[row - 1][col - 1]).to eq(color)   # col - 1 and row - 1 because arrays are zero indexed
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
        expect {@editor.process_vertical_line_command(0,1,2,"A") }.to output("command failed: V 0 1 2 A     (X out of bounds; must be between 1 and #{@editor.current_max_col})\n").to_stdout
        expect {@editor.process_vertical_line_command(9,1,2,"O") }.to output("command failed: V 9 1 2 O     (X out of bounds; must be between 1 and #{@editor.current_max_col})\n").to_stdout
        expect {@editor.process_vertical_line_command(-1,1,2,"O") }.to output("command failed: V -1 1 2 O     (X out of bounds; must be between 1 and #{@editor.current_max_col})\n").to_stdout
      end
    end
    
    context "when row inputs are out of bounds" do
      [[1,0,1,'A'],[1,1,9,'A'],[1,0,9,'A'], [1,-1,3,'A'], [1,2,-1,'A']].each do |col, row_start, row_end, color|
        it 'says "command failed"' do
          err_msg = "command failed: V #{col} #{row_start} #{row_end} #{color}     (Y out of bounds; must be between 1 and #{@editor.current_max_row})\n"
          expect {@editor.process_vertical_line_command(col,row_start,row_end, color) }.to output(err_msg).to_stdout
        end
      end
    end
    
    context "when inputs are valid" do
      it 'set color correctly with input 1,1,5,A' do
        @editor.process_vertical_line_command(1, 1, 5,'A')
        
        set_correctly =   @editor.image[0][0] == 'A'
        set_correctly &&= @editor.image[1][0] == 'A'
        set_correctly &&= @editor.image[2][0] == 'A'
        set_correctly &&= @editor.image[3][0] == 'A'
        set_correctly &&= @editor.image[4][0] == 'A'
        
        expect(set_correctly).to be true
      end
      it 'set color correctly with input 8,8,6,B' do
        @editor.process_vertical_line_command(8,8,6,'B')

        set_correctly =   @editor.image[7][7] == 'B'
        set_correctly &&= @editor.image[6][7] == 'B'
        set_correctly &&= @editor.image[5][7] == 'B'
        
        expect(set_correctly).to be true
      end
      it 'set color correctly with input 3,3,3,C' do
        @editor.process_vertical_line_command(3,3,3,'C')
        expect(@editor.image[2][2]).to eq('C')
      end
      it 'set color correctly with input 5,7,7,D' do
        @editor.process_vertical_line_command(5,7,7,'D')
        expect(@editor.image[6][4]).to eq('D')
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
      [[0,1,1,'A'],[1,9,1,'A'],[0,9,1,'A'],[-1,4,2,'A'],[3,-1,2,'A']].each do |col_start, col_end, row, color|
        it 'says "command failed"' do
          err_msg = "command failed: H #{col_start} #{col_end} #{row} #{color}     (X out of bounds; must be between 1 and #{@editor.current_max_col})\n"
          expect {@editor.process_horizontal_line_command(col_start,col_end,row, color) }.to output(err_msg).to_stdout
        end
      end
    end
    
    context "when row input is out of bounds" do
      it 'says "command fail"' do
        expect {@editor.process_horizontal_line_command(1,2,0,"A") }.to output("command failed: H 1 2 0 A     (Y out of bounds; must be between 1 and #{@editor.current_max_row})\n").to_stdout
        expect {@editor.process_horizontal_line_command(1,2,9,"O") }.to output("command failed: H 1 2 9 O     (Y out of bounds; must be between 1 and #{@editor.current_max_row})\n").to_stdout
        expect {@editor.process_horizontal_line_command(1,2,-1,"O") }.to output("command failed: H 1 2 -1 O     (Y out of bounds; must be between 1 and #{@editor.current_max_row})\n").to_stdout
      end
    end
    
    context "when inputs are valid" do
      it 'set color correctly with input 1,5,1,A' do
        @editor.process_horizontal_line_command(1,5,1,'A')
        
        set_correctly =   @editor.image[0][4] == 'A'
        set_correctly &&= @editor.image[0][3] == 'A'
        set_correctly &&= @editor.image[0][2] == 'A'
        set_correctly &&= @editor.image[0][1] == 'A'
        set_correctly &&= @editor.image[0][0] == 'A'
        
        expect(set_correctly).to be true
      end
      it 'set color correctly with input 8,6,8,B' do
        @editor.process_horizontal_line_command(8,6,8,'B')
        
        set_correctly =   @editor.image[7][5] == 'B'
        set_correctly &&= @editor.image[7][6] == 'B'
        set_correctly &&= @editor.image[7][7] == 'B'
        
        expect(set_correctly).to be true
      end
      it 'set color correctly with input 3,3,3,C' do
        @editor.process_horizontal_line_command(3,3,3,'C')
        expect(@editor.image[2][2]).to eq('C')
      end
      it 'set color correctly with input 5,7,7,D' do
        @editor.process_horizontal_line_command(5,5,7,'D')
        expect(@editor.image[6][4]).to eq('D')
      end
    end
  end
  
  
  describe '#process_clear_command' do
    context "when image not yet created" do
      it 'says "there is no image"' do
        editor = BitmapEditor.new
        expect { editor.process_clear_command() }.to output("there is no image\n").to_stdout
      end
    end
    
    context "when there is a image" do
      it 'sets the entire image to the color white (O)' do
        editor = BitmapEditor.new
        editor.process_create_command(8,8)
        expect(Helper.all_white_pixel?(editor.image)).to be true
        
        editor.process_point_command(5,5,'A')
        expect(Helper.all_white_pixel?(editor.image)).to be false
        
        editor.process_clear_command()
        expect(Helper.all_white_pixel?(editor.image)).to be true
        
      end
    end
  end
  
  
  describe '#process_show_command' do
    context "when image not yet created" do
      it 'says "there is no image"' do
        editor = BitmapEditor.new
        expect { editor.process_show_command() }.to output("there is no image\n").to_stdout
      end
    end
    
    context "when there is a image" do
      it 'outputs the image' do
        editor = BitmapEditor.new
        editor.process_create_command(5,6)
        editor.process_point_command(1,3,'A')
        editor.process_vertical_line_command(2,3,6,'W')
        editor.process_horizontal_line_command(3,5,2,'Z')
        
        expected_img_output =  "OOOOO\n"
        expected_img_output += "OOZZZ\n"
        expected_img_output += "AWOOO\n"
        expected_img_output += "OWOOO\n"
        expected_img_output += "OWOOO\n"
        expected_img_output += "OWOOO\n"
        
        expect { editor.process_show_command() }.to output(expected_img_output).to_stdout
        
        
      end
    end
  end
  
  describe '#run' do
    
    before(:each) { @editor = BitmapEditor.new}
    root = File.dirname(__dir__)
    examples_path = "#{root}/examples"
    output_path = "#{root}/examples_output"
    
    context 'given input file does not exist' do
      it 'says "please provide correct file"' do
        expect{ @editor.run("#{examples_path}/abcdefg.txt")}.to output("please provide correct file\n").to_stdout
      end
    end
    context 'normal image 1' do
      it 'outputs correctly' do
        expected_output = File.read("#{output_path}/example1.txt")
        expect{ @editor.run("#{examples_path}/example1.txt")}.to output(expected_output).to_stdout 
      end
    end
    context 'normal image 2' do
      it 'outputs correctly' do
        expected_output = File.read("#{output_path}/example2.txt")
        expect{ @editor.run("#{examples_path}/example2.txt")}.to output(expected_output).to_stdout 
      end
    end
    context 'big image with commands drawing the letters HI' do
      it 'outputs image resembling the letters HI' do
        expected_output = File.read("#{output_path}/big_img_HI.txt")
        expect{ @editor.run("#{examples_path}/big_img_HI.txt")}.to output(expected_output).to_stdout
      end
    end
    context 'no create command' do
      it 'says "there is no image" when other commands are called' do
        expected_output = File.read("#{output_path}/no_img1.txt")
        expect{ @editor.run("#{examples_path}/no_img1.txt")}.to output(expected_output).to_stdout 
      end
    end
    context 'create command after several commands in' do
      it 'says "there is no image" when calling command before a image is created, then execute the commands normally after image created' do
        expected_output = File.read("#{output_path}/create_img_after_several_commands.txt")
        expect{ @editor.run("#{examples_path}/create_img_after_several_commands.txt")}.to output(expected_output).to_stdout
      end
    end
    context 'newly created image overwrites the previous image' do
      it 'outputs the newest image created when show command is called' do
        expected_output = File.read("#{output_path}/new_image_overwrites_old_one.txt")
        expect{ @editor.run("#{examples_path}/new_image_overwrites_old_one.txt")}.to output(expected_output).to_stdout
      end
    end
    context 'newer draw command (L, V, H) overwrites pixel color set by previous draw command' do
      it 'outputs the image resulting from newest draw overwrites' do
        expected_output = File.read("#{output_path}/draw_commands_overwrites.txt")
        expect{ @editor.run("#{examples_path}/draw_commands_overwrites.txt")}.to output(expected_output).to_stdout
      end
    end
    context 'handles invalid commands gracefully, while executing valid commands normally (valid commands from example2)' do
      it 'says corresponding error messages when encountering invalid commands, and execute as normal when encountering valid commands' do
        expected_output = File.read("#{output_path}/invalid_commands_interweaving_valid_commands.txt")
        expect{ @editor.run("#{examples_path}/invalid_commands_interweaving_valid_commands.txt")}.to output(expected_output).to_stdout
      end
    end
    
  end
  
end