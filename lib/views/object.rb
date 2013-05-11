class Object
  def to_database_view(depth, ranges = {}, params = {})
    obj = {:oop => self.object_id}

    if depth > 0
      obj[:loaded] = true
      obj[:exception] = false
      obj[:classObject] = self.class.to_database_view(depth - 1, {}, params)
      obj[:virtualClassObject] = self.__virtual_class.to_database_view(depth - 1, {}, params)   # singleton class
      
      index = 1
      obj[:instVars] = {}
      obj[:instVarsSize] = self.instance_variables.size

      range_from = ranges[:instVars] ? Integer(ranges[:instVars][0]) : 1
      range_to = ranges[:instVars] ? Integer(ranges[:instVars][1]) : 10

      ((range_from - 1)..[range_to - 1, self.instance_variables.size - 1].min).each do |index|
        obj[:instVars][index + 1] = [self.instance_variables[index].to_database_view(depth - 1, {}, params), self.instance_variable_get(self.instance_variables[index]).to_database_view(depth - 1, {}, params)]
      end
    else
      obj[:loaded] = false
    end

    inspection = self.inspect
    if inspection._isString
      obj[:inspection] = inspection[0, 200]
      obj[:inspection] += "..." if obj[:inspection].size < inspection.size
    else
      obj[:inspection] = "(error)"
    end

    obj[:basetype] = :object

    obj = handle_locked_classes(obj, depth, ranges, params)

    return obj
  end

  def __evaluate_smalltalk(code)
    code.__evaluate_smalltalk_in_context(self)
  end

  primitive '__virtual_class', 'virtualClass'

  private

  def handle_locked_classes(obj, depth, ranges = {}, params = {})
    # handle classes that may not be modified

    if self.class == GsNMethod
      return __gsnmethod_to_database_view(obj, depth, ranges, params)
    end

    return obj
  end
end

