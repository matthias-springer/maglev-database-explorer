class ObjectExplorerController < ApplicationController
  def table
    obj = ObjectSpace._id2ref(Integer(params[:id]))
    render(:partial => "shared/object", :locals => {:object => obj})
  end

  def object
    @obj = ObjectSpace._id2ref(Integer(params[:id]))
    
    @class_id = @obj.class.object_id
    @ivs = {}
    @obj.instance_variables.each do |iv_name|
      @ivs[iv_name] = @obj.instance_variable_get(iv_name).object_id
    end

    respond_to do |format|
      format.html do
        render(:partial => "object")
      end

      format.json
    end
  end

  def graph
    @id = Integer(params[:id])
  end
end
