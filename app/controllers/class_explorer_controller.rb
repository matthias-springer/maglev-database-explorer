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
  end

  private

  def page_url(page)
    "/ClassExplorer/index/#{@id}?showIvs=#{@show_ivs}&page=#{page}"
  end

  helper_method :page_url

end
