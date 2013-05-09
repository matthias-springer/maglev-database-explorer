class ObjectController < ApplicationController
  def index
    id = Integer(params[:id])
    ranges = {}

    params.each_pair do |key, value|
      parts = key.split("_")
      
      if parts[0] == "range"
        ranges[parts[1].to_sym] = [params["range_#{parts[1]}_from"], params["range_#{parts[1]}_to"]]
      end
    end

    depth = params[:depth] ? Integer(params[:depth]) : 2

    render :json => {:success => true, :result => ObjectSpace._id2ref(id).to_database_view(depth, ranges)}
  end
end
