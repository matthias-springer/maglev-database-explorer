require "set"

class ClassExplorerController < ApplicationController
  def index
    @id = params[:id] ? Integer(params[:id]) : Class.object_id
    @clazz = ObjectSpace._id2ref(@id)
    @items_per_page = 10
    @page = params[:page] ? Integer(params[:page]) : 1
     
    Maglev.abort_transaction
    @objs = ObjectSpace::SystemRepository.__list_instances([@clazz], 0, nil, 2, 95, false)[1]
    @max_pages = (Float(@objs.size) / @items_per_page).ceil
    @objs = @objs[(@page - 1) * @items_per_page, @items_per_page]
    
    @ivs = Set.new
    @show_ivs = params[:showIvs]

    if (@show_ivs == "all") 
      for obj in @objs
        obj.instance_variables.each do |iv_name|
          @ivs.add(iv_name)
        end
      end
    end

    @additional_data_names = Set.new
    @additional_data = {}
    @additional_data.compare_by_identity
    
    @objs.each do |obj|
      additional_data_hash = additional_data(obj)
      additional_data_hash.keys.each do |name|
        @additional_data_names.add(name)
      end
      @additional_data[obj] = additional_data_hash
    end
  end

  private

  def additional_data(object)
    if object.class == Class or object.class == Module
      return {"Included Modules" => object.included_modules}
    else
      return {}
    end
  end

  def page_url(page)
    "/ClassExplorer/index/#{@id}?showIvs=#{@show_ivs}&page=#{page}"
  end

  helper_method :page_url

end
