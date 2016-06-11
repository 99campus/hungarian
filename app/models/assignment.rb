class Assignment

  def self.assign(arr)
    @error = 0
    @array = arr
    validate_array
    @final = @array
    return [@final,@error]
  end

  def self.validate_array
    if @array.count < 1
      @error = 1
    end
    if @array.first.kind_of?(Array)
      if @array.any? {|row| row.size != @array.first.size }
        @error = 2
      end
    end
    if @array.size != @array.first.size
      @error = 3
    end
  end
end
