class BitmapEditor
  
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

    File.open(file).each do |line|
      line = line.chomp
      case line
      when 'S'
          puts "There is no image"
      else
          puts 'unrecognised command :('
      end
    end
  end
end
