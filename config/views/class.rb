class Class
  def to_database_view(depth, range_from = 1, range_to = 10)
    # we will eventually reach Object
    obj = super

    if (range > 0)
      instances = ObjectSpace::SystemRepository.__list_instances([self], 0, nil, 2, 95, true)[1]
      obj[:elements] = []
      obj[:size] = instances.size
      obj[:basetype] = :class

      instances[range_from - 1, range_to - range_from + 1].each do |instance|
        obj[:elements].push(instance.to_database_view(depth - 1))
      end

      obj[:superclass] = self.superclass.to_database_view(depth - 1)
    end

    return obj
  end
end