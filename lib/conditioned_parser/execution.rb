module ConditionedParser
  # Docile-inspired exec wrapper for dsl - retains the context using ConditionedParser and delegates unrecognized methods and ivar accessess to the outer scope
  module Execution
    def exec_in_proxy_context(inner_context, proxy_type, *args, &block)
      outer_context = eval('self', block.binding)
      proxy_context = proxy_type.new(inner_context, outer_context)
      begin
        show_outer_ivars_to_proxy(outer_context, proxy_context)
        proxy_context.instance_exec(*args, &block)
      ensure
        update_outer_ivars_from_proxy(outer_context, proxy_context)
      end
    end
    module_function :exec_in_proxy_context

    private

    def move_ivar_between_contexts(ivar, originating_context, goal_context)
      ivar_value = originating_context.instance_variable_get(ivar)
      goal_context.instance_variable_set(ivar, ivar_value)
    end

    def show_outer_ivars_to_proxy(outer_context, proxy_context)
      outer_context.instance_variables.each do |ivar|
        move_ivar_between_contexts(ivar, outer_context, proxy_context)
      end
    end

    def update_outer_ivars_from_proxy(outer_context, proxy_context)
      outer_context.instance_variables.each do |ivar|
        move_ivar_between_contexts(ivar, proxy_context, outer_context)
      end
    end
  end
end
