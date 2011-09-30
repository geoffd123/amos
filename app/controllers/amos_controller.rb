module Amos
  class AmosController < ApplicationController
    unloadable
    def all
      @model = params[:model].camelize
      render :json =>  self.instance_eval("#{@model}.all")
    end
  end
end
