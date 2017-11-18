# Bitmaps are represented as an M x N matrix of pixels with each
# element representing a colour.
class Bitmap
  MIN_COL = 1
  MIN_ROW = 1

  attr_reader :max_col, :max_row

  def initialize(col_size, row_size)
    if col_size < 1 || row_size < 1
      raise ArgumentError, 'column size and row size must be greate than 0'
    end

    @max_col = col_size
    @max_row = row_size

    @pixel_2d_array = []
    row_size.times { @pixel_2d_array.push(Array.new(col_size, 'O')) }
  end

  def set_pixel_color(col1, col2, row1, row2, color)
    if !valid_column_range?(col1, col2) || !valid_row_range?(row1, row2)
      error_msg = "column must be within #{MIN_COL} and #{@max_col}; "
      error_msg += "row must be within #{MIN_ROW} and #{@max_row}"
      raise ArgumentError, error_msg
    end

    cols = [col1, col2].sort
    rows = [row1, row2].sort

    col_start = cols[0]
    col_end = cols[1]
    row_start = rows[0]
    row_end = rows[1]

    col_start.upto(col_end) do |col|
      row_start.upto(row_end) do |row|
        @pixel_2d_array[row - 1][col - 1] = color
      end
    end
  end

  def get_pixel_color(col, row)
    @pixel_2d_array[row][col]
  end

  def to_a
    @pixel_2d_array
  end

  def valid_column_range?(col1, col2)
    valid_column?(col1) && valid_column?(col2)
  end

  def valid_row_range?(row1, row2)
    valid_row?(row1) && valid_row?(row2)
  end

  def valid_column?(col)
    MIN_COL <= col && col <= @max_col
  end

  def valid_row?(row)
    MIN_ROW <= row && row <= @max_row
  end
end
