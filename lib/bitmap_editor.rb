require_relative 'bitmap.rb'
require_relative 'command_validator.rb'

# A basic interactive bitmap editor
class BitmapEditor
  include CommandValidator
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

    begin
      validate(command)
    rescue ArgumentError => arg_error
      return puts arg_error.message
    end

    @previous_command = command
    args = command.split(' ')

    case args[0]
    when 'I'
      col_size = args[1].to_i
      row_size = args[2].to_i
      process_create_command(col_size, row_size)
    when 'C'
      process_clear_command
    when 'L'
      col = args[1].to_i
      row = args[2].to_i
      color = args[3]
      process_point_command(col, row, color)
    when 'V'
      col = args[1].to_i
      row1 = args[2].to_i
      row2 = args[3].to_i
      color = args[4]
      process_vertical_line_command(col, row1, row2, color)
    when 'H'
      col1 = args[1].to_i
      col2 = args[2].to_i
      row = args[3].to_i
      color = args[4]
      process_horizontal_line_command(col1, col2, row, color)
    when 'S'
      process_show_command
    else
      puts "unrecognised command :( : #{command}"
    end
  end

  ############# command processing, interaction with Bitmap #############

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
    return puts 'there is no image' if @bitmap.nil?
    set_pixel_color(1, @bitmap.col_size, 1, @bitmap.row_size, 'O')
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
    return puts 'there is no image' if @bitmap.nil?
    @bitmap.to_a.each { |row| puts row.join('') }
  end

  def set_pixel_color(col1, col2, row1, row2, color)
    return puts 'there is no image' if @bitmap.nil?

    begin
      @bitmap.set_pixel_color(col1 - 1, col2 - 1, row1 - 1, row2 - 1, color)
    rescue ArgumentError
      error_msg = "command failed: #{@previous_command}     "
      error_msg += "column must be within #{MIN_SUPPORTED_COL} and #{@bitmap.col_size}; "
      error_msg += "row must be within #{MIN_SUPPORTED_ROW} and #{@bitmap.row_size}"
      puts error_msg
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

  ############## helper methods ##############

  def valid_size?(col_size, row_size)
    valid = MIN_SUPPORTED_COL <= col_size && col_size <= MAX_SUPPORTED_COL
    valid && MIN_SUPPORTED_ROW <= row_size && row_size <= MAX_SUPPORTED_ROW
  end
end
