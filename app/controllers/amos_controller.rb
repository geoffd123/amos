module Amos
  class AmosController < ApplicationController

    unloadable

    def all
      @model = params[:model].camelize
      render :json =>  self.instance_eval("#{@model}.all")
    end

    def with_id
      @model = params[:model].camelize
      render :json =>  self.instance_eval("#{@model}.find(#{params[:id]})")
    end

  end
end
