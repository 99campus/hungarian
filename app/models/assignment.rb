class Assignment

  attr_accessor :matrix, :covered_columns, :covered_rows, :starred_zeros, :primed_zeros, :primed_starred_series

  def self.assign(arr)
    @error = 0
    @array = arr
    @original = @array
    @starred_zeros = []
    @primed_zeros = []
    @covered_columns = []
    @covered_rows = []
    validate_array
    min_sub_row
    star_zeros
    cover_columns_with_stars

    while not (0...@array.first.size).to_a.size == @covered_columns.size
      p = cover_zeros_and_create_more
      find_better_stars p
      #create series
      cover_columns_with_stars
    end
    @final = @starred_zeros.delete_if{|row_index,col_index| col_index >= @original.first.size || row_index >= @original.size}
    return [@final,@error]
  end

  def self.validate_array
    if @array.count < 2
      @error = 1
    elsif @array.first.kind_of?(Array)
      if @array.any? {|row| row.size != @array.first.size }
        @error = 2
      end
    elsif @array.size != @array.first.size
      @error = 3
    end
  end

  def self.min_sub_row
    @array.each_with_index do |row,i_row|
      minimum = row.index(0) ? 0 : row.min
      row.each_with_index do |value, i_col|
        @array[i_row][i_col] = value - minimum
      end
    end
  end

  def self.star_zeros 
    unstarred_columns = (0...@array.first.size).to_a
    
    @array.each_with_index do |row, row_index|
      star = @starred_zeros.any? {|row_in,col_in| row_in == row_index}
      next if star
      unstarred_columns.each do |col_index|
          if (row[col_index] == 0 and !@starred_zeros.any? {|row_in,col_in| col_in == col_index})
          @starred_zeros << [row_index, col_index]
          unstarred_columns -= [col_index]
          break # go to next row
        end
      end
    end
  end

  def self.cover_columns_with_stars
    cols = @starred_zeros.collect {|z| z[1]}
    cols.uniq!
    @covered_columns += cols
  end

  def self.cover_zeros_and_create_more
    loop do
      while prime = prime_first_uncovered_zero
        if star = @starred_zeros.assoc(prime[0])
          @covered_rows << prime[0]
          @covered_columns -= [star[1]] 
        else
          return prime
        end
      end
      
      add_and_subtract_for_step_6(smallest_uncovered_value)
    end
  end

  def self.prime_first_uncovered_zero
    my_cols = (0...@array.first.size).to_a - @covered_columns
    
    uncovered_rows.each do |row_index|
      my_cols.each do |col_index|
        if @array[row_index][col_index] == 0
          @primed_zeros << [row_index, col_index]
          return [row_index, col_index]
        end
      end
    end
    nil
  end

  def self.uncovered_rows
    (0...@array.size).to_a - @covered_rows 
  end

  def self.find_better_stars(first_zero)
    primes_series = [first_zero]
    stars_series = []
    while next_star = @starred_zeros.detect{|row, col| col == primes_series.last[1] }
      stars_series << next_star
      primes_series << @primed_zeros.detect{|row, col| row == stars_series.last[0] }
    end
    stars_series.each do |star|
      @starred_zeros.delete(star)
    end
    
    primes_series.each do |prime|
      @starred_zeros << prime
    end
    
    @primed_zeros = []
    @covered_columns = []
    @covered_rows = []
  end

  def self.add_and_subtract_for_step_6(delta=0)
    @covered_rows.each do |row_index|
      @covered_columns.each do |col_index|
        @array[row_index][col_index] += delta
      end
    end


    my_cols = (0...@array.first.size).to_a - @covered_columns #silly workaround to cache the list
    
    uncovered_rows.each do |row_index|
      my_cols.each do |col_index|
        @array[row_index][col_index] -= delta
      end
    end
  end

  def self.smallest_uncovered_value
    min_value = nil 
    my_cols = (0...@array.first.size).to_a - @covered_columns #silly workaround to cache the list
    uncovered_rows.each do |row_index|
      my_cols.each do |col_index|
        value = @array[row_index][col_index]
        min_value ||= value
        min_value = value if value < min_value
        return 0 if min_value == 0
      end
    end
    min_value
  end

end
