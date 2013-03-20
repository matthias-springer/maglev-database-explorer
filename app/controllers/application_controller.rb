class ApplicationController < ActionController::Base
  protect_from_forgery

  def object_dropdown_begin(parameters)
    _render_template(:partial => "shared/dropdown_object_begin", :locals => parameters)
  end

  def object_dropdown_end(parameters)
    _render_template(:partial => "shared/dropdown_object_end", :locals => parameters)
  end

  helper_method :object_dropdown_begin
  helper_method :object_dropdown_end
end
