class GsNMethodProxy
  def self.for(method)
    instance = self.new
    instance.method = method
    instance
  end

  def __for_database_explorer
    [@method.__source_string, @method.__environment_id, @method.__selector, @method.__file_and_line]
  end

  def method=(val)
    @method = val
  end
end

class GsNMethod
  primitive '__source_string', 'sourceString'
  primitive '__environment_id', 'environmentId'
  primitive '__description_for_stack', '_descrForStack'
  primitive '__selector', 'selector'
  primitive '__file_and_line', '_fileAndLine'
  primitive '__source_offsets', '_sourceOffsets'
  primitive '__source_offsets_at', '_sourceOffsetsAt:'
  primitive '__previous_step_point_for_ip', '_previousStepPointForIp:'
  primitive '__source_at_ip', '_sourceAtTosIp:'
  primitive '__step_point_for_ip', '_stepPointForIp:level:isNative:'
end

