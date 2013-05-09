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

  def evaluate
    obj = ObjectSpace._id2ref(Integer(params[:id]))
    code = params[:code]
    language = params[:language]
    depth = params[:depth] ? Integer(params[:depth]) : 2
    ranges = {}

    if obj == nil
      render :json => {:success => false, :exception => "object not found"}
    else
      begin
        result = nil

        if language == "smalltalk"
          result = code.__evaluate_smalltalk_in_instance(obj)
        elsif language == "ruby"
          result = obj.instance_eval(code)
        end

        # save object
        Maglev::PERSISTENT_ROOT[:debug_storage] ||= {}
        Maglev::PERSISTENT_ROOT[:debug_storage][result.object_id] = result

        render :json => {:success => true, :result => result.to_database_view(depth, ranges)}
      rescue Exception => exc
        render :json => {:success => true, :result => exc.to_database_view(depth, ranges)}
      end
    end
  end
end

