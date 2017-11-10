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
  
  
  def process_create_command(column_size, row_size)
  end
  
  def process_clear_command()
  end
  
  def process_point_command(column_number, row_number, color)
  end
  
  def process_vertical_line_command(column_number, row_number_start, row_number_end, color)
  end
  
  def process_horizontal_line_command(column_number_start, column_number_end, row_number, color)
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
