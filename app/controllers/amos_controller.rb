
  class AmosController < ApplicationController

    unloadable

    before_filter :set_model
    before_filter :set_current_record, :only => [:show, :update]
    
    def index
      records = self.instance_eval("#{@model}.all")
      result_records = []
      records.each{|rec|
        result = filter_record rec
        result_records << result
      } unless records.nil?
      render :json => result_records 
    end

    def show
      result = filter_record @record
      @the_associations = process_association_names([], params[:association])
      if @the_associations.count > 0
        @the_associations.each{|name|
          assoc_records = self.instance_eval("@record.#{name}")
          data = []
          assoc_records.each{|ar|
            data << filter_record(ar, ["#{@model.downcase}_id"])
          }
          result[name] = data
        }
      end
      render :json => result
     end
     
   def destroy
     begin
       set_current_record
       @record.destroy
       render :json => {:success => "true"}
     rescue ActiveRecord::RecordNotFound => e
       render :json => {:success => "false"}
     end
    end
    
    def create
      p = remove_attributes_from ['id', 'model', 'controller', 'action'], params.clone 
      record = self.instance_eval("#{@model}.new(p)")
     
      if record.save
          result = filter_record record
          render :json => result
        else
          render :json => record.errors
        end
    end
    
    def update
      attributes = remove_attributes_from ['id', 'model', 'controller', 'action'], params.clone 
      if @record.update_attributes(attributes)
        render :json => {:success => "true"}
      else
        render :json => {:success => "false"}
      end
    end

  protected
  
    def set_model
      m = params[:model]
      m.chop! if m.end_with? 's'
      @model = m.camelize
    end
  
    def set_current_record
        @record = self.instance_eval("#{@model}.find(#{params[:id]})")
     end
    
    def filter_record record, extras = nil
      data = remove_attributes_from ['created_at', 'updated_at'], record.attributes.clone 
      data = remove_attributes_from extras , data unless extras.nil?
      data
    end
    
    def remove_attributes_from attribute_names, collection
      attribute_names.each{|key| collection.delete(key)}     
      collection
    end
    
    def process_association_names assocs, names
      return [] if names.nil?
      names.split(',').each{|n| assocs << n}
    end
  end

