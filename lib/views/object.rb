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
      obj[:inspect] = self.inspect
    else
      obj[:loaded] = false
    end

    return obj
  end
end

