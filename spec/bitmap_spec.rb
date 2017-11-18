require 'bitmap.rb'
require 'helper.rb'

RSpec.describe 'Bitmap' do
  describe 'constructor' do
    context 'when argument is invalid' do
      it 'rejects column size that is 0' do
        expect { Bitmap.new(0, 1) }.to raise_error(ArgumentError)
      end
      it 'rejects column size that is negative' do
        expect { Bitmap.new(-1, 1) }.to raise_error(ArgumentError)
      end
      it 'rejects row size that is 0' do
        expect { Bitmap.new(1, 0) }.to raise_error(ArgumentError)
      end
      it 'rejects row size that is negative' do
        expect { Bitmap.new(1, -1) }.to raise_error(ArgumentError)
      end
    end
    context 'when argument is valid (3,4)' do
      bitmap = Bitmap.new(3, 4)
      it 'sets @max_col to 3' do
        expect(bitmap.max_col).to eq(3)
      end
      it 'sets @max_row to 4' do
        expect(bitmap.max_row).to eq(4)
      end
      it 'set pixel_2d_array to a 2d array of the right size' do
        pixel_2d_array = bitmap.to_a
        expect(pixel_2d_array.length).to eq(4)
        expect(pixel_2d_array[0].length).to eq(3)
      end
      it 'set all elements in @pixel_2d_array to white (O)' do
        pixel_2d_array = bitmap.to_a
        expect(Helper.all_white_pixel?(pixel_2d_array)).to be true
      end
    end
  end

  describe '#valid_column?' do
    bitmap = Bitmap.new(4, 5)
    it 'returns true when the argument is within column boundaries' do
      expect(bitmap.valid_column?(1)).to be true
      expect(bitmap.valid_column?(4)).to be true
    end
    it "returns false when the argument is less than column's lower bound (1)" do
      expect(bitmap.valid_column?(0)).to be false
      expect(bitmap.valid_column?(-1)).to be false
    end
    it "returns false when the argument is greater than column's upper bound (4)" do
      expect(bitmap.valid_column?(5)).to be false
    end
  end

  describe '#valid_row?' do
    bitmap = Bitmap.new(5, 6)
    it 'returns true when the argument is within row boundaries' do
      expect(bitmap.valid_row?(1)).to be true
      expect(bitmap.valid_row?(6)).to be true
    end
    it "returns false when the argument is less than row's lower bound (1)" do
      expect(bitmap.valid_row?(0)).to be false
      expect(bitmap.valid_row?(-1)).to be false
    end
    it "returns false when the argument is greater than row's upper bound(6)" do
      expect(bitmap.valid_row?(7)).to be false
    end
  end

  describe '#valid_column_range?' do
    bitmap = Bitmap.new(6, 7)
    context 'when the given range is within bounds' do
      valid_ranges = [[1, 6], [6, 1], [3, 6], [5, 1]]
      valid_ranges.each do |col1, col2|
        it 'returns true' do
          expect(bitmap.valid_column_range?(col1, col2)).to be true
        end
      end
    end
    context 'when the given range is out of bounds' do
      invalid_lower_bounds = [[-1, -5], [-2, 0], [-1, 4], [0, 5]]
      invalid_upper_bounds = [[1, 7], [15, 10]]
      invalid_bounds = [[0, 7], [11, -11]]
      invalid_ranges = invalid_lower_bounds + invalid_upper_bounds + invalid_bounds
      invalid_ranges.each do |col1, col2|
        it 'returns false' do
          expect(bitmap.valid_column_range?(col1, col2)).to be false
        end
      end
    end
  end

  describe '#valid_row_range?' do
    bitmap = Bitmap.new(7, 8)
    context 'when the given range is within bounds' do
      valid_ranges = [[1, 8], [1, 5], [4, 8], [6, 2]]
      valid_ranges.each do |row1, row2|
        it 'returns true' do
          expect(bitmap.valid_row_range?(row1, row2)).to be true
        end
      end
    end
    context 'when the given range is out of bounds' do
      invalid_lower_bounds = [[-1, -5], [-2, 0], [-1, 4], [0, 5]]
      invalid_upper_bounds = [[1, 9], [15, 10]]
      invalid_bounds = [[0, 9], [11, -11]]
      invalid_ranges = invalid_lower_bounds + invalid_upper_bounds + invalid_bounds
      invalid_ranges.each do |row1, row2|
        it 'returns false' do
          expect(bitmap.valid_row_range?(row1, row2)).to be false
        end
      end
    end
  end

  describe '#set_pixel_color' do
    context 'when arguments are out of bounds' do
      bitmap = Bitmap.new(8, 9)
      invalid_cols = [[0, 1, 1, 5, 'A'], [9, 1, 6, 3, 'A'], [0, 9, 9, 1, 'A'], [8, -1, 1, 9, 'A']]
      invalid_rows = [[8, 8, 0, 1, 'A'], [8, 1, 10, 1, 'A'], [4, 7, 0, 10, 'A'], [5, 1, -1, 9, 'A']]
      invalid_both = [[0, 1, 0, 1, 'A'], [-1, 1, 1, -1, 'A'], [9, -1, -1, 10, 'A'], [0, 5, 3, -2, 'A']]
      invalid_args = invalid_cols + invalid_rows + invalid_both
      invalid_args.each do |c1, c2, r1, r2, color|
        it 'raises error' do
          expect { bitmap.set_pixel_color(c1, c2, r1, r2, color) }.to raise_error(ArgumentError)
        end
      end
    end
    context 'when arguments are in bounds' do
      before(:each) { @bitmap = Bitmap.new(8, 9) }
      it 'set color for a single pixel when col1 == col2 and row1 == row2' do
        @bitmap.set_pixel_color(1, 1, 1, 1, 'A')
        expect(@bitmap.get_pixel_color(0, 0)).to eq('A')
      end
      it 'set color for pixels on a vertical line when col1 == col2 and row1 != row2' do
        @bitmap.set_pixel_color(2, 2, 1, 3, 'B')
        set_correctly = @bitmap.get_pixel_color(1, 0) == 'B'
        set_correctly &&= @bitmap.get_pixel_color(1, 1) == 'B'
        set_correctly &&= @bitmap.get_pixel_color(1, 2) == 'B'
        expect(set_correctly).to be true
      end
      it 'set color for pixels on a horizontal line when col1 != col2 and row1 == row2' do
        @bitmap.set_pixel_color(4, 2, 5, 5, 'C')
        set_correctly = @bitmap.get_pixel_color(3, 4) == 'C'
        set_correctly &&= @bitmap.get_pixel_color(2, 4) == 'C'
        set_correctly &&= @bitmap.get_pixel_color(1, 4) == 'C'
        expect(set_correctly).to be true
      end
    end
  end
end
