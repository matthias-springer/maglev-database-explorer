class Object
  def to_database_view(depth, ranges = {})
    obj = {:oop => self.object_id}

    if depth > 0
      obj[:loaded] = true
      obj[:classObject] = self.class.to_database_view(depth - 1)

      index = 1
      obj[:instVars] = {}
      obj[:instVarsSize] = self.instance_variables.size

      range_from = ranges[:instVars] ? Integer(ranges[:instVars][0]) : 1
      range_to = ranges[:instVars] ? Integer(ranges[:instVars][1]) : 10

      ((range_from - 1)..[range_to - 1, self.instance_variables.size - 1].min).each do |index|
        obj[:instVars][index + 1] = [self.instance_variables[index].to_database_view(depth - 1), self.instance_variable_get(self.instance_variables[index]).to_database_view(depth - 1)]
      end
    else
      obj[:loaded] = false
    end

    inspection = self.inspect
    obj[:inspection] = inspection[0, 200]
    obj[:inspection] += "..." if obj[:inspection].size < inspection.size
    
    obj[:basetype] = :object

    return obj
  end
end

