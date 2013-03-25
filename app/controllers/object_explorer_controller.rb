class ObjectExplorerController < ApplicationController
  def table
    obj = ObjectSpace._id2ref(Integer(params[:id]))
    render(:partial => "shared/object", :locals => {:object => obj, :short => params[:short] == "1" ? true : false})
  end

  def object
    @obj = ObjectSpace._id2ref(Integer(params[:id]))

    respond_to do |format|
      format.html do
        render(:partial => "object")
      end

      format.json
    end
  end

  def graph
    @id = Integer(params[:id])
  end

  private

  def references(obj)
    refs = []

    obj.instance_variables.each do |iv_name|
      refs << ["iv", iv_name, obj.instance_variable_get(iv_name).object_id]
    end
    
    method_name = "references_#{obj.class.to_s.downcase}"
    begin
      refs += self.send(method_name, obj)
    rescue NoMethodError
    
    end
    
    return refs
  end

  helper_method :references

  def references_hash(obj)
    refs = []

    obj.each do |key, value|
      refs << ["hash_key", value.object_id, key.object_id]
      refs << ["hash_value", key.object_id, value.object_id]
    end

    return refs
  end
  
  def references_array(obj)
    refs = []

     (0..obj.length - 1).each do |index|
      refs << ["array_element", index, obj[index].object_id]
    end

    return refs
  end

end
