 require 'cancan'
 require 'ruby-debug'
 
  class AmosController < ApplicationController

    unloadable

    before_filter :set_model
    before_filter :set_current_record, :only => [:show, :update, :destroy]
    #before_filter :should_paginate
    
    def index
      options = remove_attributes_from ['fields', 'model', 'controller', 'action'], params.clone
      options.underscore_keys!
      records = self.instance_eval("#{@model}.list(options)")
      render :json => {
        :data => records.limit(params[:limit]).offset(params[:offset]).as_json(params[:fields]),
        :offset => params[:offset],
        :limit => params[:limit],
        :count => records.count
      }
    end

  def show
    render :json => @record.as_json(params[:fields])
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
      attributes = remove_attributes_from ['fields','id', 'model', 'controller', 'action'], params.clone
      attributes.underscore_keys!
      attributes = set_association_keys_for(@model, attributes)
      record = self.instance_eval("#{@model}.new(attributes)")

      if record.save
          render :json => record.as_json(params[:fields])
      else
          render :json => record.errors, :status => 400
      end
    else
      render_authorized
    end
  end
    
  def update
    if can? :update, eval("#{@model}")
      attributes = remove_attributes_from ['fields', 'id', 'model', 'controller', 'action'], params.clone
      attributes.underscore_keys!
      attributes = set_association_keys_for(@model, attributes)

      if @record.update_attributes(attributes)
        render :json => record.as_json(params[:fields])
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

    def remove_attributes_from attribute_names, collection
      attribute_names.each{|key| collection.delete(key)}
      collection
    end
  
    def set_current_record
      begin
        @record = self.instance_eval("#{@model}.find(#{params[:id]})")
      rescue ActiveRecord::RecordNotFound => e
        render :json => {:error => "Record #{params[:id]} not found"}, :status => 400
      end
    end

    def render_authorized
      render :json => {:error => "You are not authorized to access this data"}, :status => 401
    end


    
  end

