require_relative 'bitmap.rb'

# A basic interactive bitmap editor
class BitmapEditor
  attr_reader :bitmap, :previous_command

  MIN_SUPPORTED_COL = 1
  MAX_SUPPORTED_COL = 250
  MIN_SUPPORTED_ROW = 1
  MAX_SUPPORTED_ROW = 250

  def initialize
    @bitmap = nil
    @previous_command = nil
  end

  def run(file)
    return puts 'please provide correct file' if file.nil? || !File.exist?(file)
    File.open(file).each { |line| parse_command(line) }
  end

  def parse_command(command)
    command = command.chomp
    command_array = command.split(' ')
    @previous_command = command

    case command_array[0]
    when 'I'
      # valid create command: "I M N"
      # M is an integer specifying column size, N is an integer specifying row size
      if command_array.length != 3
        puts "wrong number of arguments: #{command}"
      elsif BitmapEditor.integer?(command_array[1]) && BitmapEditor.integer?(command_array[2])
        col_size = command_array[1].to_i
        row_size = command_array[2].to_i
        process_create_command(col_size, row_size)
      else
        puts "wrong type of arguments: #{command}"
      end
    when 'C'
      # valid clear command: "C"
      if command_array.length == 1
        process_clear_command
      else
        puts "wrong number of arguments: #{command}"
      end
    when 'L'
      # valid point command: "L X Y C"
      # X is an integer specifying column number, Y is an integer specifying row number, C is a capital letter specifying color
      if command_array.length != 4
        puts "wrong number of arguments: #{command}"
      elsif BitmapEditor.integer?(command_array[1]) && BitmapEditor.integer?(command_array[2]) && BitmapEditor.valid_color?(command_array[3])
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
      elsif BitmapEditor.integer?(command_array[1]) && BitmapEditor.integer?(command_array[2]) && BitmapEditor.integer?(command_array[3]) && BitmapEditor.valid_color?(command_array[4])
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
      elsif BitmapEditor.integer?(command_array[1]) && BitmapEditor.integer?(command_array[2]) && BitmapEditor.integer?(command_array[3]) && BitmapEditor.valid_color?(command_array[4])
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
        process_show_command
      else
        puts "wrong number of arguments: #{command}"
      end
    else
      puts "unrecognised command :( : #{command}"
    end
  end

  ############# command processing ####################

  def process_create_command(col_size, row_size)
    if valid_size?(col_size, row_size)
      @bitmap = Bitmap.new(col_size, row_size)
    else
      error_msg = "command failed: #{@previous_command}     "
      error_msg += "column size must be within #{MIN_SUPPORTED_COL} and #{MAX_SUPPORTED_COL}, "
      error_msg += "row size must be within #{MIN_SUPPORTED_ROW} and #{MAX_SUPPORTED_ROW}"
      puts error_msg
    end
  end

  def process_clear_command
    if @bitmap.nil?
      puts 'there is no image'
    else
      set_pixel_color(1, @bitmap.col_size, 1, @bitmap.row_size, 'O')
    end
  end

  def process_point_command(col, row, color)
    set_pixel_color(col, col, row, row, color)
  end

  def process_vertical_line_command(col, row_start, row_end, color)
    set_pixel_color(col, col, row_start, row_end, color)
  end

  def process_horizontal_line_command(col_start, col_end, row, color)
    set_pixel_color(col_start, col_end, row, row, color)
  end

  def process_show_command
    if @bitmap.nil?
      puts 'there is no image'
    else
      @bitmap.to_a.each { |row| puts row.join('') }
    end
  end

  ########## draw, interacting with Bitmap ########

  def set_pixel_color(col1, col2, row1, row2, color)
    if @bitmap.nil?
      puts 'there is no image'
    else
      begin
        @bitmap.set_pixel_color(col1 - 1, col2 - 1, row1 - 1, row2 - 1, color)
      rescue ArgumentError
        error_msg = "command failed: #{@previous_command}     "
        error_msg += "column must be within #{MIN_SUPPORTED_COL} and #{@bitmap.col_size}; "
        error_msg += "row must be within #{MIN_SUPPORTED_ROW} and #{@bitmap.row_size}"
        puts error_msg
      end
    end
  end

  def get_pixel_color(col, row)
    @bitmap.get_pixel_color(col - 1, row - 1)
  end

  def column_size
    @bitmap.col_size
  end

  def row_size
    @bitmap.row_size
  end

  ############## class methods ################
  def valid_size?(col_size, row_size)
    valid = MIN_SUPPORTED_COL <= col_size && col_size <= MAX_SUPPORTED_COL
    valid && MIN_SUPPORTED_ROW <= row_size && row_size <= MAX_SUPPORTED_ROW
  end

  def self.integer?(string)
    !/\A[-+]?\d+\z/.match(string).nil?
  end

  def self.valid_color?(string)
    (string.length == 1 && !/\A[A-Z]\z/.match(string).nil?)
  end
end
