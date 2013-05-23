class CodeController < ApplicationController
  def index
        
  end

  def selectors
    id = Integer(params[:id])
    obj = ObjectSpace._id2ref(id)
  
    if obj == nil and id != 20
      render :json => {:success => false, :exception => "object with id #{id} not found"}
    else
      render :json => {:success => true, :result => obj.__selectors_by_category}
    end
  end

  def code
    id = Integer(params[:id])
    obj = ObjectSpace._id2ref(id)

    if obj == nil and id != 20
      render :json => {:success => false, :exception => "object with id #{id} not found"}
    else
      render :json => {:success => true, :result => obj.__source_for_selector(params[:selector], params[:language].to_sym)}
    end
  end

  def frame
    id = Integer(params[:id])
    index = Integer(params[:index])
    obj = ObjectSpace._id2ref(id)

    if obj == nil and id != 20
      render :json => {:success => false, :exception => "object with id #{id} not found"}
    else
      render :json => {:success => true, :result => obj.__stack_frame(index)}
    end
  end

  def frames
    id = Integer(params[:id])
    obj = ObjectSpace._id2ref(id)

    if obj == nil and id != 20
      render :json => {:success => false, :exception => "object with id #{id} not found"}
    else
      render :json => {:success => true, :result => obj.__stack_method_names}
    end
  end

  def stepInto
    id = Integer(params[:id])
    obj = ObjectSpace._id2ref(id)

    if obj == nil and id != 20
      render :json => {:success => false, :exception => "object with id #{id} not found"}
    else
      render :json => {:success => true, :result => obj.__step_into.to_database_view(1, {}, {})}
    end
  end

  def proceed
    id = Integer(params[:id])
    obj = ObjectSpace._id2ref(id)

    if obj == nil and id != 20
      render :json => {:success => false, :exception => "object with id #{id} not found"}
    else
      result = obj.run
      sleep 0.1 until obj.stop? and obj[:manual_stop]
      render :json => {:success => true, :result => result}
    end
  end

  def trim
    id = Integer(params[:id])
    obj = ObjectSpace._id2ref(id)
    index = Integer(params[:index])

    if obj == nil and id != 20
      render :json => {:success => false, :exception => "object with id #{id} not found"}
    else
      obj.__trim_stack_to_level(index)
      render :json => {:success => true, :result => true}
    end
  end

  def stepOver
    id = Integer(params[:id])
    index = Integer(params[:index])
    obj = ObjectSpace._id2ref(id)

    if obj == nil and id != 20
      render :json => {:success => false, :exception => "object with id #{id} not found"}
    else
      render :json => {:success => true, :result => obj.__step_over_at(index).to_database_view(1, {}, {})}
    end
  end

end
