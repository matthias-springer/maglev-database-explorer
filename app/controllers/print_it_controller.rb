class PrintItController < ApplicationController
  
  def smalltalk
    render :json => evaluate(params[:id], params[:code], :smalltalk)
  end

  def ruby
    render :json => evaluate(params[:id], params[:code], :ruby)   
  end

  def evaluateAndSet
    evaluation = evaluate(params[:id], params[:code], :ruby)
    
    if evaluation["status"] == "ok"
      setting = evaluate(params[:id], params[:setter] + "ObjectSpace._id2ref(#{evaluation["result"]})", :ruby)

      if setting["status"] == "ok"
        render :json => evaluation
      else
        render :json => setting
      end
    else
      render :json => evaluation
    end
  end

  private

  def evaluate(id, code, language)
    obj = ObjectSpace._id2ref(Integer(id))

    if obj == nil
      return {"status" => "object_not_found"}
    else
      begin
        result = nil

        if language == :smalltalk
          result = code.__evaluate_smalltalk_in_instance(obj)
        elsif language == :ruby
          result = obj.instance_eval(code)
        end

        # save object
        Maglev::PERSISTENT_ROOT[:debug_storage] ||= {}
        Maglev::PERSISTENT_ROOT[:debug_storage][result.object_id] = result

        return {"status" => "ok", "result" => result.object_id}
      rescue Exception => exc
        return {"status" => "exception", "result" => exc.inspect}
      end
    end
  end

end
