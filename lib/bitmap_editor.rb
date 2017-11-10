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
      if command_array.length != 3
        puts "wrong number of arguments: #{command}"
      end
    when 'C'
      if command_array.length != 1
        puts "wrong number of arguments: #{command}"
      end
    when 'L'
      if command_array.length != 4
        puts "wrong number of arguments: #{command}"
      end
    when 'V'
      if command_array.length != 5
        puts "wrong number of arguments: #{command}"
      end
    when 'H'
      if command_array.length != 5
        puts "wrong number of arguments: #{command}"
      end
    when 'S'
      if command_array.length != 1
        puts "wrong number of arguments: #{command}"
      end
      
      #puts "There is no image"
    else
      puts "unrecognised command :( : #{command}"
    end
  
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
