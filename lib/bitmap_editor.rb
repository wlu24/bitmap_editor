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
    else
      puts "unrecognised command :( : #{command}"
    end
  
  end
  
  
  ############# command processing ####################
  
  
  def process_create_command(col_size, row_size)
    if (0 < col_size and col_size <= @@max_col ) and (0 < row_size and row_size <= @@max_row )
      # if arguments are in bounds, create a new image of size col_size X row_size
      @current_max_col = col_size
      @current_max_row = row_size
      
      @image = []
      row_size.times { @image.push( Array.new(col_size, "O")) }
      
    else
      # if arguments are out of bounds, print error message
      err_msg = "create image failed: I #{col_size} #{row_size}" 
      err_msg += "     (inputs out of bound; column size must be between 1 and #{@@max_col},"
      err_msg += " row size must be between 1 and #{@@max_row})"
      puts err_msg
      
    end
  end
  
  def process_clear_command()
    if @image.nil?
      puts "there is no image"
    else
      # set every pixel color to white (O) 
      @image.each_with_index do |row, row_index|
        row.each_with_index { |pixel_color, col_index| @image[row_index][col_index] = 'O' }
      end
    end
  end
  
  def process_point_command(col, row, color)
    if @image.nil?
      puts "there is no image"
    elsif 0 < col and col <= @current_max_col and 0 < row and row <= @current_max_row
      # if inputs are valid, set pixel to color
      @image[row - 1][col - 1] = color
    else
      # if inputs are out of bound, print error message
      err_msg = "command failed: L #{col} #{row} #{color}"
      err_msg += "     (input out of bound; max col is #{@current_max_col}, max row is #{@current_max_row})"
      puts err_msg
    end
  end
  
  def process_vertical_line_command(col, row_start, row_end, color)
    # vertical_line range can start with either row_start or row_end
    if @image.nil?
      puts "there is no image"
    elsif col < 1 or col > @current_max_col
      # if col is out of bound, print error message
      puts "command failed: V #{col} #{row_start} #{row_end} #{color}     (column input out of bounds)"
    elsif 0 < row_start and row_start <= @current_max_row and 0 < row_end and row_end <= @current_max_row
      # if the inputs are valid, set the pixels with the color accordingly
    
      if row_start < row_end
        row_start.upto(row_end) {|row| @image[row-1][col-1] = color}
      else
        # if row_start and row_end are in reverse order, starts with row_end
        row_end.upto(row_start) {|row| @image[row-1][col-1] = color}
      end
    else
      # if row input is out of bound, print error message
      puts "command failed: V #{col} #{row_start} #{row_end} #{color}     (row input out of bounds)"
    end
  end
  
  def process_horizontal_line_command(col_start, col_end, row, color)
    if @image.nil?
      puts "there is no image"
    elsif row < 1 or row > @current_max_row
      # if row is out of bound, print error message
      puts "command failed: H #{col_start} #{col_end} #{row} #{color}     (row input out of bounds)"
    elsif 0 < col_start and col_start <= @current_max_col and 0 < col_end and col_end <= @current_max_col
      # if the inputs are valid, set the pixels with the color accordingly
      if col_start < col_end
        col_start.upto(col_end) {|col| @image[row-1][col-1] = color }
      else
        # if col_start and col_end are in reverse order, start with col_end
        col_end.upto(col_start) {|col| @image[row-1][col-1] = color }
      end
    else
      # if column is out of bound, print error message
      puts "command failed: H #{col_start} #{col_end} #{row} #{color}     (column input out of bounds)"
    end
  end
  
  def process_show_command()
    if @image.nil?
      puts "there is no image"
    else
      # output the image, one row per line
      @image.each { |row| puts row.join("") }
    end
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
