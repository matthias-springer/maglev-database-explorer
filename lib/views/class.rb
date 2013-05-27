class Class
  def __basetype
    :class
  end

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

    if params[:subclasses] && depth > 1 # requests usually start at a depth of 2
      obj[:subclasses] = __subclasses.to_a.sort_by {|c| c.to_s}.reverse.to_database_view(2, {}, {:allElements => true, :noBehavior => true})
    end
    
    if params[:instances] && depth > 1 # requests usually start at a depth of 2
      range_from = ranges[:instances] ? Integer(ranges[:instances][0]) : 1
      range_to = ranges[:instances] ? Integer(ranges[:instances][1]) : 10
      
      instances = ObjectSpace::SystemRepository.__list_instances([self], 0, nil, 2, 95, true)[1]

      params_instances = {:noBehavior => true}

      obj[:instancesSize] = instances.size
      obj[:instances] = {}
      #obj[:instancesBasetype] = self.method(:__basetype).__bind(nil).call

      ((range_from - 1)..[range_to - 1, instances.size - 1].min).each do |index|
        obj[:instances][index + 1] = instances[index].to_database_view(depth - 1, {}, params_instances)
      end
    end

    return obj
  end

  primitive '__subclasses', 'subclasses'
end
