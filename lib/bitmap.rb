class Bitmap
  MIN_COL = 1
  MIN_ROW = 1

  attr_reader :max_col, :max_row

  def initialize(col_size, row_size)
  end

  def set_pixel_color(col1, col2, row1, row2, color)
  end

  def get_pixel_color(col, row)
  end

  def to_a
  end

  def valid_column_range?(col1, col2)
  end

  def valid_row_range?(row1, row2)
  end

  def valid_column?(col)
  end

  def valid_row?(row)
  end
end
