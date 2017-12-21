module ConditionedParser
  # Essentially inspired by Docile, exposes external scope to DSL blocks
  class FallbackContextProxy
    NON_PROXIED_METHODS = %i[__send__ object_id __id__ == equal? '!' '!=' instance_exec instance_variables instance_variable_get instance_variable_set remove_instance_variable].freeze

    NON_PROXIED_INSTANCE_VARIABLES = %i[@__receiver__ @__fallback__].freeze

    instance_methods.each do |method|
      undef_method(method) unless NON_PROXIED_METHODS.include?(method)
    end

    def initialize(receiver, fallback)
      @__receiver__ = receiver
      @__fallback__ = fallback
    end

    def instance_variables
      super.reject { |v| NON_PROXIED_INSTANCE_VARIABLES.include?(v.to_sym) }
    end

    def method_missing(method, *args, &block)
      if @__receiver__.respond_to?(method.to_sym)
        @__receiver__.__send__(method.to_sym, *args, &block)
      else
        @__fallback__.__send__(method.to_sym, *args, &block)
      end
    end
  end
end
