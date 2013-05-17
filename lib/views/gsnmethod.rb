# GsNMethod may not be modified
class GsNMethodProxy
  def self.for(method)
    instance = self.new
    instance.method = method
    instance
  end

  def method=(val)
    @method = val
  end

  def source_string
    @method.__evaluate_smalltalk('self sourceString')
  end

  def env_id
    @method.__evaluate_smalltalk('self environmentId')
  end

  def description_for_stack
    @method.__evaluate_smalltalk('self _descrForStack')
  end

  def selector
    @method.__evaluate_smalltalk('self selector')
  end

  def filename_line
    @method.__evaluate_smalltalk('self _fileAndLine')
  end

  def __for_database_explorer
    @method.__evaluate_smalltalk('{self sourceString. self environmentId. self selector. self _fileAndLine}')
  end

  def source_offsets
    @method.__evaluate_smalltalk('self _sourceOffsets')
  end

  def source_offsets_at(step_point)
    @method.__evaluate_smalltalk("self _sourceOffsetsAt: #{step_point}")
  end

  def previous_step_point_for_ip(ip)
    @method.__evaluate_smalltalk("self _previousStepPointForIp: #{ip}")
  end

  def source_at_ip(ip) 
    @method.__evaluate_smalltalk("self _sourceAtTosIp: #{ip}")
  end

  def step_point_for_ip(ip, index, is_native_stack)
    @method.__evaluate_smalltalk("self _stepPointForIp: #{ip} level: #{index} isNative: #{is_native_stack}")
  end
end

