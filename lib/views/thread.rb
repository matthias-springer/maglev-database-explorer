class Thread
  def __basetype
    :thread
  end

  def to_database_view(depth, ranges = {}, params = {})
    obj = super

    if depth > 0
      obj[:exception] = __exception.to_database_view(depth - 1, {}, {}) 
      obj[:threadLocalStorage] = __environment.to_database_view(1, {}, {})
      obj[:threadLocalStorageSize] = __environment ? __environment.size : -1
      obj[:status] = self.status.to_s
    end

    return obj
  end

  primitive '__continue', '_continue'
  primitive '__environment', '_environment'
  primitive '__local_frame_contents_at', '_localFrameContentsAt:'
  primitive '__local_stack_depth', 'localStackDepth'
  primitive '__local_method_at', 'localMethodAt:'
  primitive '__is_native_stack', '_nativeStack'
  primitive '__step_over_in_frame', '_stepOverInFrame:'
  primitive '__step_into', '_stepInto'
  primitive '__trim_stack_to_level', '_localTrimStackToLevel:'
  
  def __set_exception(exception)
    self[:last_exception] = exception
  end

  def __exception
    self[:last_exception]
  end

  def __step_over_at(frame)
    thread = Thread.start(self) do |debug_thread|
      Thread.pass
      debug_thread.__step_over_in_frame(frame)
    end

    sleep 0.1 unless thread.stop?
  end

  def __source_offset_for(frame, level)
    # (frame at: 1) _sourceOffsetsAt: ((frame at: 1) _previousStepPointForIp: (frame at: 2))
    method = frame[0]
    method.__source_offsets_at(method.__step_point_for_ip(frame[1], level, __is_native_stack))
  end

  def __source_with_break_for(frame)
    # (frame at: 1) _sourceOffsetsAt: ((frame at: 1) _previousStepPointForIp: (frame at: 2))
    method = frame[0]
    method.__source_at_ip(frame[1])
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

    method = frame[0]
    source_offset = __source_offset_for(frame, index)
    source_string = method.__source_string
    
    # magic numbers copied from GsProcess 
    # [GsNMethod, ipOffset, frameOffset, varContext (nil), saveProtectionMode, markerOrException, nil (not used), self, argAndTempNames, receiver, args and temps, source offset, x-y source offset...
    [GsNMethodProxy.for(method).__for_database_explorer, frame[1], frame[2], nil, frame[4], frame[5].to_database_view(1, {}, {}), nil, frame[7].to_database_view(1, {}, {}), frame[8], frame[9].to_database_view(1, {}, {}), arg_values, source_offset, __xy_position_in_string(source_string, source_offset), __source_with_break_for(frame)]
  end
  
  def __stack_method_names
    methods = []

    (1..__local_stack_depth).each do |idx|
      method = __local_method_at(idx)
      methods.push(method.__description_for_stack) if method != nil  # TODO: why do we need to check for nil here?
    end

    methods
  end

end
