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
    obj = ObjectSpace._id2ref(Integer(params[:id]))
    code = params[:code]
    language = params[:language]
    depth = params[:depth] ? Integer(params[:depth]) : 2
    ranges = {}

    if obj == nil
      render :json => {:success => false, :exception => "object not found"}
    else
      eval_thread = Thread.start do
        begin
          if language == "smalltalk"
            obj.__evaluate_smalltalk(code)
          elsif language == "ruby"
            obj.instance_eval(code)
          elsif language == "rubyClass"
            obj.class_eval(code)
          end
        rescue Exception => exc
          cc = callcc { |cont| cont }
          cc.instance_variable_set("@exception", exc)
          cc
        end
      end 
      
      # XXX: FIXME: make all this inst-var-setting go away - maybe add temp_set/temp_get to Continuation?
      # then you can just do result.temp_get("exc")
      # ...
      # or rather add stack frame access to continuations and allow us to get temps from frames ...
      # rubymirrors should already do what you want here
      if (result = eval_thread.value).is_a? Continuation
        exc = result.instance_variable_get("@exception")
        exc.instance_variable_set("@thread", result.instance_variable_get("@_st_process"))        
        result = exc
      end

      store_object(result)
      render :json => {:success => true, :result => result.to_database_view(depth, ranges, params)}
    end
  end

  private
  
  def store_object(obj)
    Maglev::PERSISTENT_ROOT[:debug_storage] ||= {}
    Maglev::PERSISTENT_ROOT[:debug_storage][obj.object_id] = obj
  end

end

