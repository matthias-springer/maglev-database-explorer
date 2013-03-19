class PrintItController < ApplicationController
  def ruby
    obj = ObjectSpace._id2ref(Integer(params[:id]))

    if obj == nil
      render :json => {"status" => "object_not_found"}
    else
      begin
        result = obj.instance_eval(params[:code])
        
        # save object
        Maglev::PERSISTENT_ROOT[:debug_storage] ||= {}
        Maglev::PERSISTENT_ROOT[:debug_storage][result.object_id] = result

        render :json => {"status" => "ok", "result" => result.object_id}
      rescue Exception => exc
        render :json => {"status" => "exception", "result" => exc.inspect}
      end
    end
  end
end
