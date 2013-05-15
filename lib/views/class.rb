class Class
  def to_database_view(depth, ranges = {}, params = {})
    # we will eventually reach Object
    obj = super

    if depth > 0 and not params[:noBehavior]
      #instances = ObjectSpace::SystemRepository.__list_instances([self], 0, nil, 2, 95, true)[1]
      #obj[:size] = instances.size

      #instances[range_from - 1, range_to - range_from + 1].each do |instance|
      #  obj[:elements].push(instance.to_database_view(depth - 1))
      #end

      obj[:superclassObject] = self.superclass.to_database_view(depth - 1, {}, params)
    end

    obj[:basetype] = :class
    
    return obj
  end
end
