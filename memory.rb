class Memory

  @current_memory
  @file_name

  def initialize file_path = "./memory.txt"
    raise TypeError, "String expected" if !file_path.is_a? String
    @file_name = file_path
    @current_memory = Array.new
    loadMemory() if File.exists? @file_name
  end

  def writeMemory content
    raise TypeError, "String or Array expected" if !(content.is_a?(String) || content.is_a?(Array))
    raise ArgumentError, "Nil argument given" if !content
    mem_file = File.open @file_name, "w"
    mem_file << content if content.is_a? String
    content.each {|line| mem_file << "#{line}\n"} if content.is_a? Array
    mem_file.close()
  end

  def getMemory
    return @current_memory
  end

  private

  def loadMemory
    mem_file = File.open @file_name, "r"
    mem_file.each do |line|
      @current_memory.push line.chomp
    end
    mem_file.close
  end

end
