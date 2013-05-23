class CodeEvaluation
  class << self
    def wait_for_eval_thread(&block)
      eval_thread = Thread.start do
        value_proc = Proc.new(&block)

        value_proc.__call_and_rescue do |eval_result|
          is_exception = eval_result[0]

          if is_exception
            Thread.current.__set_exception(eval_result[1])
            eval_result[1] = Thread.current
          else
            Thread.current.__set_exception(nil)
          end

          Thread.current[:result] = eval_result
          Thread.current[:manual_stop] = true

          if is_exception
            Thread.stop
            Thread.current[:manual_stop] = false
            eval_result[1].__exception.__resume
          end
        end

        Thread.current[:manual_stop] = true
      end
      
      sleep 0.1 until eval_thread.stop? and eval_thread[:manual_stop]

      result = eval_thread[:result]
      return result
    end
  end
end
