class AssignmentsController < ApplicationController
  def new
    if params[:array].kind_of?(Array)
      array = eval(params[:array])
      @final_array = Assignment.assign(array)
      if @final_array[1] > 0
        @final_value = "Array is not good"
      else
        @final_value = @final_array[0]
      end
    else
      @final_value = "Please use proper format of array"
    end
    respond_to do |format|
      format.js
    end
  end
end
