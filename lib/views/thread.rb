class Thread
  def to_database_view(depth, ranges = {}, params = {})
    obj = super
    obj[:basetype] = :thread
    return obj
  end

  primitive '__local_frame_contents_at', '_localFrameContentsAt:'
  primitive '__local_stack_depth', 'localStackDepth'
  primitive '__local_method_at', 'localMethodAt:'
  primitive '__is_native_stack', '_nativeStack'
  primitive '__step_over_at', '_stepOverInFrame:'
  primitive '__step_into', '_stepInto'

  def __source_offset_for(frame, level)
    # (frame at: 1) _sourceOffsetsAt: ((frame at: 1) _previousStepPointForIp: (frame at: 2))
    method_proxy = GsNMethodProxy.for(frame[0])
    #previous_step_point = method_proxy.previous_step_point_for_ip(frame[1])
    #method_proxy.source_offsets_at(previous_step_point)
    method_proxy.source_offsets_at(method_proxy.step_point_for_ip(frame[1], level, __is_native_stack))
  end

  def __source_with_break_for(frame)
    # (frame at: 1) _sourceOffsetsAt: ((frame at: 1) _previousStepPointForIp: (frame at: 2))
    method_proxy = GsNMethodProxy.for(frame[0])
    method_proxy.source_at_ip(frame[1])
  end

  def __xy_position_in_string(string, offset)
    substr = string[0, offset]
    y = substr.count("\n")
    x = nil

    if substr[-1] == "\n"
      x = 0
    else
      x = substr.split("\n").last.size - 1
    end

    return [x, y]
  end

  def __stack_frame(index)
    frame = __local_frame_contents_at(index)

    arg_values = []
    (10..frame.size - 1).each do |idx|
      arg_values.push(frame[idx].to_database_view(1, {}, {}))
    end

    method_proxy = GsNMethodProxy.for(frame[0])
    source_offset = __source_offset_for(frame, index)
    source_string = method_proxy.source_string
    
    # magic numbers copied from GsProcess 
    # [GsNMethod, ipOffset, frameOffset, varContext (nil), saveProtectionMode, markerOrException, nil (not used), self, argAndTempNames, receiver, args and temps, source offset, x-y source offset...
    [method_proxy.__for_database_explorer, frame[1], frame[2], nil, frame[4], frame[5].to_database_view(1, {}, {}), nil, frame[7].to_database_view(1, {}, {}), frame[8], frame[9].to_database_view(1, {}, {}), arg_values, source_offset, __xy_position_in_string(source_string, source_offset), __source_with_break_for(frame)]
  end
  
  def __stack_method_names
    methods = []

    (1..__local_stack_depth).each do |idx|
      methods.push(GsNMethodProxy.for(__local_method_at(idx)).description_for_stack)
    end

    methods
  end
end
