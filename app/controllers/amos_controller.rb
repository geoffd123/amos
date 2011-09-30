module Amos
  class AmosController < ApplicationController
    unloadable
    def access
      @model = params[:model].camelize
      @method = params[:method]
      @result = eval "#{@model}.#{@method}"
      render :json =>  @result
    end
  end
end
