 require 'cancan'
 
  class AmosController < ApplicationController

    unloadable

    before_filter :set_model
    before_filter :set_current_record, :only => [:show, :update, :destroy]
    
    def index
      @the_fields = process_field_names([], params[:fields])
      records = self.instance_eval("#{@model}.all")
      result_records = []
      records.each{|rec|
        if @the_fields.count == 0
          result = filter_record rec
        else
          result = select_fields rec, @the_fields
        end
        result_records << result
      } unless records.nil?
      render :json => result_records 
    end

    def find
      @the_fields = process_field_names([], params[:fields])
      terms = params[:term].split(',').collect{|t| "'#{t}'"}.join(',')
      p "terms = #{terms}"
      records = self.instance_eval("#{@model}.find_#{params[:query]}(#{terms})")
      result_records = []
      records.each{|rec|
        if @the_fields.count == 0
          result = filter_record rec
        else
          result = select_fields rec, @the_fields
        end
        result_records << result
      } unless records.nil?
      render :json => result_records 
    end
    
    def show
      @the_fields = process_field_names([], params[:fields])
      if @the_fields.count == 0
        result = filter_record @record
      else
        result = select_fields @record, @the_fields
      end
      
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
     if can? :delete, @record
       @record.destroy
       render :json => {:success => "true"}
     else
       render_authorized
     end
    end
    
    def create
      if can? :create, eval("#{@model}")
        p = remove_attributes_from ['id', 'model', 'controller', 'action'], params.clone 
        record = self.instance_eval("#{@model}.new(p)")

        if record.save
            result = filter_record record
            render :json => result
        else
            render :json => record.errors, :status => 400
        end
      else
        render_authorized
      end
    end
    
    def update
      if can? :update, eval("#{@model}")
        attributes = remove_attributes_from ['id', 'model', 'controller', 'action'], params.clone 
        if @record.update_attributes(attributes)
          render :json => attributes
        else
          render :json => @record.errors, :status => 400
        end
      else
        render_authorized
      end
    end

  protected
  
    def set_model
      m = params[:model]
      m.chop! if m.end_with? 's'
      @model = m.camelize
      if cannot? :read, eval("#{@model}")
        render_authorized
      end
    end
  
    def set_current_record
      begin
        @record = self.instance_eval("#{@model}.find(#{params[:id]})")
      rescue ActiveRecord::RecordNotFound => e
        render :json => {:error => "Record #{params[:id]} not found"}, :status => 400
      end
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
    
    def process_field_names fields, names
      return [] if names.nil?
      names.split(',').each{|n| fields << n}
    end
    
    def select_fields record, fields
      selected_fields = {}
      record.attributes.each_pair{|key, value|
        if fields.include?(key) 
          selected_fields[key] = value
        end
      }
      selected_fields
    end
    
    def render_authorized
      render :json => {:error => "You are not authorized to access this data"}, :status => 401
    end
  end

