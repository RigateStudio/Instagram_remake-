# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
    protect_from_forgery unless: -> { request.format.json? }
  
      def render_jsonapi_response(resource)
        if resource.errors.empty?
          render jsonapi: resource
        else
          render jsonapi_errors: resource.errors, status: 400
        end
      end
    
    end