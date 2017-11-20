# Validates user typed in commands given to BitmapEditor
module CommandValidator
  WRONG_NUM = 'wrong number of arguments'.freeze
  WRONG_TYPE = 'wrong type of arguments'.freeze

  # check the command for correct input length and correct input type
  def validate(command)
    args = command.split(' ')

    case args[0]
    when 'C', 'S'
      raise ArgumentError, "#{WRONG_NUM}: #{command}" unless args.length == 1
    when 'I'
      raise ArgumentError, "#{WRONG_NUM}: #{command}" unless args.length == 3

      int1 = integer?(args[1])
      int2 = integer?(args[2])
      raise ArgumentError, "#{WRONG_TYPE}: #{command}" unless int1 && int2
    when 'L'
      raise ArgumentError, "#{WRONG_NUM}: #{command}" unless args.length == 4

      int1 = integer?(args[1])
      int2 = integer?(args[2])
      color = valid_color?(args[3])
      correct_types = int1 && int2 && color
      raise ArgumentError, "#{WRONG_TYPE}: #{command}" unless correct_types
    when 'V', 'H'
      raise ArgumentError, "#{WRONG_NUM}: #{command}" unless args.length == 5

      int1 = integer?(args[1])
      int2 = integer?(args[2])
      int3 = integer?(args[3])
      color = valid_color?(args[4])
      correct_types = int1 && int2 && int3 && color
      raise ArgumentError, "#{WRONG_TYPE}: #{command}" unless correct_types
    else
      raise ArgumentError, "unrecognised command :( : #{command}"
    end
  end

  def integer?(string)
    !/\A[-+]?\d+\z/.match(string).nil?
  end

  def valid_color?(string)
    (string.length == 1 && !/\A[A-Z]\z/.match(string).nil?)
  end
end
