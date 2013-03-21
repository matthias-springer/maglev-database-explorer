class ObjectExplorerController < ApplicationController
  def table
    obj = ObjectSpace._id2ref(Integer(params[:id]))
    render(:partial => "shared/object", :locals => {:object => obj})
  end

  def data
    obj = ObjectSpace._id2ref(Integer(params[:id]))
    
    class_id = obj.class.object_id
    ivs = {}
    obj.instance_variables.each do |iv_name|
      ivs[iv_name] = obj.instance_variable_get(iv_name).object_id
    end

    render :json => {"id" => Integer(params[:id]), "class" => class_id, "ivs" => ivs}
  end
end
