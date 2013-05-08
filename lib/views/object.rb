class Object
  def to_database_view(depth, range_from = 1, range_to = 10)
    obj = {:oop => self.object_id, :class => self.class.object_id}

    if depth > 0
      obj[:loaded] = true
      obj[:instVars] = {}
      obj[:basetype] = :object

      self.instance_variables.each do |iv_name|
        obj[:instVars][iv_name] = self.instance_variable_get(iv_name).to_database_view(depth - 1)
      end

      obj[:classObject] = self.class.to_database_view(depth - 1)
    else
      obj[:loaded] = false
    end

    inspection = self.inspect
    obj[:inspection] = inspection[0, 200]
    obj[:inspection] += "..." if obj[:inspection].size < inspection.size

    return obj
  end
end

