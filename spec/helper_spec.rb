require 'helper.rb'

RSpec.describe 'Helper' do
  describe '#all_white_pixel?' do
    it "returns true when all elements of the 2d array are 'O'" do
      sample_array = [%w[O O O], %w[O O O]]
      expect(Helper.all_white_pixel?(sample_array)).to be true
    end
    it "returns false when not all elements of the 2d array are 'O'" do
      sample_array = [%w[O A O], %w[O O O]]
      expect(Helper.all_white_pixel?(sample_array)).to be false
    end
  end
end
