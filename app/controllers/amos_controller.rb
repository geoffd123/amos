module Amos
  class AmosController < ApplicationController

    unloadable

    def all
      @model = params[:model].camelize
      render :json =>  self.instance_eval("#{@model}.all")
    end

    def with_id
      @model = params[:model].camelize
      result = self.instance_eval("#{@model}.find(#{params[:id]})")
      render :json => result.to_json 
    end

  end
end
