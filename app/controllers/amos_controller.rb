module Amos
  class AmosController < ApplicationController

    unloadable

    def all
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

    def with_id
      @model = params[:model].camelize
      record = self.instance_eval("#{@model}.find(#{params[:id]})")
      
      result = {}
      
      filter_record result, record
      render :json => result
     end
     
  protected
  
    def filter_record result, record
      record.attributes.each_pair{|key, value|
        result[key] = value if (key != 'created_at' && key != 'updated_at')
      }
    end
  end
end
