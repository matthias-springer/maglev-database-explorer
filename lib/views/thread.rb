class Thread
  def to_database_view(depth, ranges = {}, params = {})
    obj = super
    obj[:basetype] = :thread
    return obj
  end

  primitive '__local_frame_contents_at', '_localFrameContentsAt:'
  primitive '__local_stack_depth', 'localStackDepth'
  primitive '__local_method_at', 'localMethodAt:'

  def __stack_frame(index)
    frame = __local_frame_contents_at(index)
    
    # [GsNMethod, ipOffset, frameOffset, varContext (nil), saveProtectionMode, markerOrException, nil (not used), self, argAndTempNames, receiver, args and temps...
    result = [GsNMethodProxy.for(frame[0]).__for_database_explorer, frame[1], frame[2], nil, frame[4], frame[5].to_database_view(1, {}, {}), nil, frame[7].to_database_view(1, {}, {}), frame[8], frame[9].to_database_view(1, {}, {})]

    (10..frame.size - 1).each do |idx|
      result.push(frame[idx].to_database_view(1, {}, {}))
    end

    result
  end
  
  def __stack_method_names
    methods = []

    (1..__local_stack_depth).each do |idx|
      methods.push(GsNMethodProxy.for(__local_method_at(idx)).description_for_stack)
    end

    methods
  end
end
