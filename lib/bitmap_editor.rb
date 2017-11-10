class BitmapEditor
  
  @@max_col = 250
  @@max_row = 250
  
  attr_reader :image
  attr_reader :current_max_col
  attr_reader :current_max_row
  
  
  def initialize()
    @image = nil
    @current_max_col = 0
    @current_max_row = 0
  end


  def run(file)
    return puts "please provide correct file" if file.nil? || !File.exists?(file)
    File.open(file).each { |line| parse_command(line) }
    
  end
  
  
  
  
  def parse_command(command)
    
    command = command.chomp
    command_array = command.split(' ')
    
    
    case command_array[0]
    when 'I'  
      # valid create command: "I M N"
      # M is an integer specifying column size, N is an integer specifying row size
      if command_array.length != 3
        puts "wrong number of arguments: #{command}"
      elsif BitmapEditor.integer?(command_array[1]) and BitmapEditor.integer?(command_array[2])
        col_size = command_array[1].to_i
        row_size = command_array[2].to_i
        process_create_command(col_size, row_size)
      else
        puts "wrong type of arguments: #{command}"
      end
    when 'C'
      # valid clear command: "C"
      if command_array.length == 1
        process_clear_command()
      else
        puts "wrong number of arguments: #{command}"
      end
    when 'L'
      # valid point command: "L X Y C"
      # X is an integer specifying column number, Y is an integer specifying row number, C is a capital letter specifying color
      if command_array.length != 4
        puts "wrong number of arguments: #{command}"
      elsif BitmapEditor.integer?(command_array[1]) and BitmapEditor.integer?(command_array[2]) and BitmapEditor.valid_color?(command_array[3])
        col = command_array[1].to_i
        row = command_array[2].to_i
        color = command_array[3]
        process_point_command(col, row, color)
      else
        puts "wrong type of arguments: #{command}"
      end
    when 'V'
      # valid vertical line command: "V X Y1 Y2 C"
      # X is an integer specifying column number, Y1 is an integer specifying row start number
      # Y2 is an integer specifying row end number, C is a capital letter specifying color
      if command_array.length != 5
        puts "wrong number of arguments: #{command}"
      elsif BitmapEditor.integer?(command_array[1]) and BitmapEditor.integer?(command_array[2]) and BitmapEditor.integer?(command_array[3]) and BitmapEditor.valid_color?(command_array[4])
        col = command_array[1].to_i
        row_start = command_array[2].to_i
        row_end = command_array[3].to_i
        color = command_array[4]
        process_vertical_line_command(col, row_start, row_end, color)
      else
        puts "wrong type of arguments: #{command}"
      end
    when 'H'
      # valid horizontal line command: "H X1 X2 Y C"
      # X1 is an integer specifying column start number, X2 is an integer specifying column end number
      # Y is an integer specifying row number, C is a capital letter specifying color
      if command_array.length != 5
        puts "wrong number of arguments: #{command}"
      elsif BitmapEditor.integer?(command_array[1]) and BitmapEditor.integer?(command_array[2]) and BitmapEditor.integer?(command_array[3]) and BitmapEditor.valid_color?(command_array[4])
        col_start = command_array[1].to_i
        col_end = command_array[2].to_i
        row = command_array[3].to_i
        color = command_array[4]
        process_horizontal_line_command(col_start, col_end, row, color)
      else
        puts "wrong type of arguments: #{command}"
      end
    when 'S'
      # valid show command: "S"
      if command_array.length == 1
        process_show_command()
      else
        puts "wrong number of arguments: #{command}"
      end
      
      #puts "There is no image"
    else
      puts "unrecognised command :( : #{command}"
    end
  
  end
  
  
  ############# command processing ####################
  
  
  def process_create_command(col_size, row_size)
    if (0 < col_size and col_size <= @@max_col ) and (0 < row_size and row_size <= @@max_row )
      # if arguments are in bounds
      @current_max_col = col_size
      @current_max_row = row_size
      
      @image = []
      row_size.times { @image.push( Array.new(col_size, "O")) }
      
    else
      # if arguments are out of bounds
      err_msg = "create image failed: I #{col_size} #{row_size}" 
      err_msg += "     (inputs out of bound; column size must be between 1 and #{@@max_col},"
      err_msg += " row size must be between 1 and #{@@max_row})"
      puts err_msg
      
    end
  end
  
  def process_clear_command()
  end
  
  def process_point_command(col, row, color)
    if @image.nil?
      puts "there is no image"
    elsif 0 < col and col <= @current_max_col and 0 < row and row <= @current_max_row
      @image[col - 1][row - 1] = color
    else
      err_msg = "command failed: L #{col} #{row} #{color}"
      err_msg += "     (input out of bound; max col is #{@current_max_col}, max row is #{@current_max_row})"
      puts err_msg
    end
  end
  
  def process_vertical_line_command(col, row_start, row_end, color)
  end
  
  def process_horizontal_line_command(col_start, col_end, row_number, color)
  end
  
  def process_show_command()
  end
  
  
  
  ############## class methods ################
  
  
  def self.integer?(string)
    return !/\A[-+]?\d+\z/.match(string).nil?
  end
  
  def self.valid_color?(string)
    return ( (string.length == 1) and (!/\A[A-Z]\z/.match(string).nil?)  )
  end
  
  
  def self.max_col
    @@max_col
  end
  
  def self.max_row
    @@max_row
  end
  
  
end
