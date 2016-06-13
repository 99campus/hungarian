class AssignmentsController < ApplicationController
  def new
    begin
      array = eval(params[:array])
      @orig = eval(params[:array])
      @final_array = Assignment.assign(array)
      if @final_array[1] > 0
        @error_point = @final_array[1]
        @final_value = "Array is not good"
      else
        @error_point = @final_array[1]
        @final_index = @final_array[0]
        @final_value = Assignment.formatize(@orig,@final_array[0])
      end
    rescue Exception => exc
      @error_point = 2
      @final_value = "Array not good"
    end
    respond_to do |format|
      format.js
    end
  end
end
