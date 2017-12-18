module ConditionedParser
  # enables dynamic filter definition for model collections
  # defines methods following the pattern filter_*collection*_by_*attribute*
  module Filter
    def filter_for(coll, attr)
      filter = proc do |value|
        send(coll).select { |element| element.send(attr) == value }
      end
      self.class.send(:define_method, "filter_#{coll}_by_#{attr}".to_sym, filter)
    end

    def respond_to_missing?(method, _)
      method.to_s.start_with?('filter') || super
    end

    def method_missing(method, *args, &block)
      if method.to_s.start_with?('filter_')
        coll = method.to_s.match(/(?<=filter_)(.*)(?=_by)/)[0].to_sym
        attr = method.to_s.match(/(?<=_by_)(.*)/)[0].to_sym
        filter_for(coll, attr)
        __send__(method, *args, &block)
      else
        super
      end
    end
  end
end
