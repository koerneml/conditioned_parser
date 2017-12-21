module ConditionedParser
  # Docile-inspired exec wrapper for dsl - retains the context using ConditionedParser and delegates unrecognized methods and ivar accessess to the outer scope
  module Execution
    def exec_in_proxy_context(inner_context, proxy_type, *args, &block)
      outer_context = eval('self', block.binding)
      proxy_context = proxy_type.new(inner_context, outer_context)
      begin
        outer_context.instance_variables.each do |ivar|
          value_from_outer = outer_context.instance_variable_get(ivar)
          proxy_context.instance_variable_set(ivar, value_from_outer)
        end
        proxy_context.instance_exec(*args, &block)
      ensure
        outer_context.instance_variables.each do |ivar|
          value_from_proxy = proxy_context.instance_variable_get(ivar)
          outer_context.instance_variable_set(ivar, value_from_proxy)
        end
      end
    end
    module_function :exec_in_proxy_context
  end
end
