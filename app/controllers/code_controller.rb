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
end
