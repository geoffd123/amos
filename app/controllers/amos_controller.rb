module Amos
  class AmosController < ApplicationController

    unloadable

    def index
      @model = params[:model].camelize
      records = self.instance_eval("#{@model}.all")
      result_records = []
      records.each{|rec|
        result = {}
        filter_record result, rec
        result_records << result
      } unless records.nil?
      render :json => result_records 
    end

    def show
      @model = params[:model].camelize
      record = self.instance_eval("#{@model}.find(#{params[:id]})")
      
      result = {}
      
      filter_record result, record
      render :json => result
     end
     
   def destroy
     @model = params[:model].camelize
     
     begin
       record = self.instance_eval("#{@model}.find(#{params[:id]})")
       record.destroy
       render :json => {:success => "true"}
     rescue Exception => e
       render :json => {:success => "false"}
     end
    end
    
    def update
      @model = params[:model].camelize
      record = self.instance_eval("#{@model}.find(#{params[:id]})")
      attributes = Hash.new 
      params.each_pair{|p, v| attributes[p] = v}
      attributes.delete('id')
      attributes.delete('model')
      attributes.delete('controller')
      attributes.delete('action')     
      if record.update_attributes(attributes)
        render :json => {:success => "true"}
      else
        render :json => {:success => "false"}
      end
    end

  protected
  
    def filter_record result, record
      record.attributes.each_pair{|key, value|
        result[key] = value if (key != 'created_at' && key != 'updated_at')
      }
    end
  end
end
