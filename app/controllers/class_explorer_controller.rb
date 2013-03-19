require "set"

class ClassExplorerController < ApplicationController
  def index
    if params[:id]
      @clazz = ObjectSpace._id2ref(Integer(params[:id]))
      @max_items = Integer(params[:maxItems])

      Maglev.abort_transaction
      @objs = ObjectSpace::SystemRepository.__list_instances([@clazz], @max_items, nil, 2, 95, false)[1][0, @max_items]
      @ivs = Set.new
      @show_ivs = params[:showIvs]
       
      if (@show_ivs == "all") 
        for obj in @objs
          obj.instance_variables.each do |iv_name|
            @ivs.add(iv_name)
          end
        end
      end
    end
  end
end
