class ObjectExplorerController < ApplicationController
  def table
    obj = ObjectSpace._id2ref(Integer(params[:id]))
    render(:partial => "shared/object", :locals => {:object => obj})
  end
end
