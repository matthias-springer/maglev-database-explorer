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

    render :json => {:success => true, :result => ObjectSpace._id2ref(id).to_database_view(depth, ranges, params)}
  end

  def evaluate
    obj_id = Integer(params[:id])
    obj = ObjectSpace._id2ref(obj_id)
    code = params[:code]
    language = params[:language]
    depth = params[:depth] ? Integer(params[:depth]) : 2
    ranges = {}

    if obj == nil and obj_id != 20
      render :json => {:success => false, :exception => "object not found"}
    else
      result = CodeEvaluation.wait_for_eval_thread do
        if language == "smalltalk"
          obj.__evaluate_smalltalk(code)
        elsif language == "ruby"
          obj.instance_eval(code)
        elsif language == "rubyClass"
          obj.module_eval(code)
        end
      end

      store_object(result)

      if result[0]
        # exception was catched
        render :json => {:success => true, :result => [true, result[1].to_database_view(1, ranges, params)]}
      else
        # no exception was catched
        render :json => {:success => true, :result => [false, result[1].to_database_view(depth, ranges, params)]}
      end
    end
  end

  private
  
  def store_object(obj)
    Maglev::PERSISTENT_ROOT[:debug_storage] ||= {}
    Maglev::PERSISTENT_ROOT[:debug_storage][obj.object_id] = obj
  end

end

