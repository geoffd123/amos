module Amos
  class AmosController < ApplicationController
    unloadable
    def access
      @model = params[:model].camelize
      method = params[:method]
      render :json =>  self.instance_eval("#{@model}.#{method}")
    end
  end
end
