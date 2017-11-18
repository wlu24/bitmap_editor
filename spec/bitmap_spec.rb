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
end
