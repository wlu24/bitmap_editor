# helper functions for specs
module Helper
  # check if every pixel is set to white (O)
  def self.all_white_pixel?(array_2d)
    is_all_white_pixels = true
    array_2d.each do |row|
      break unless is_all_white_pixels

      row.each do |pixel|
        if pixel != 'O'
          is_all_white_pixels = false
          break
        end
      end
    end

    is_all_white_pixels
  end
end
