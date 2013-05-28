class Object
  def __basetype
    :object
  end

  def custom_database_tabs
    # [["Demo Tab", "demoData", "html with: 'This is an example'."]]
    []
  end

  def to_database_view(orig_depth, ranges = {}, params = {})
    obj = {:oop => self.object_id}

    depth = param_modify_depth(orig_depth, ranges, params)

    if depth > 0
      obj[:loaded] = true
      obj[:exception] = false
      obj[:classObject] = self.class.to_database_view(depth - 1, {}, params)
      obj[:virtualClassObject] = self.__virtual_class.to_database_view(depth - 1, {}, params)   # singleton class
      
      obj[:instVars] = {}
      obj[:instVarsSize] = 0

      if depth == 2
        obj[:customTabs] = self.custom_database_tabs
      else
        obj[:customTabs] = []
      end

      if render_inst_vars
        index = 1
        range_from = ranges[:instVars] ? Integer(ranges[:instVars][0]) : 1
        range_to = ranges[:instVars] ? Integer(ranges[:instVars][1]) : 10

        obj[:instVarsSize] = self.instance_variables.size

        ((range_from - 1)..[range_to - 1, self.instance_variables.size - 1].min).each do |index|
          obj[:instVars][index + 1] = [self.instance_variables[index].to_database_view(depth - 1, {}, params), self.instance_variable_get(self.instance_variables[index]).to_database_view(depth - 1, {}, params)]
        end
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

    obj[:basetype] = __basetype

    return obj
  end

  def __evaluate_smalltalk(code)
    code.__evaluate_smalltalk_in_context(self)
  end

  primitive '__virtual_class', 'virtualClass'

  protected

  def render_inst_vars
    true
  end

  private

  def param_modify_depth(depth, ranges, params)
    depth
  end
end

