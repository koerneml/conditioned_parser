module ConditionedParser
  module Matcher
    def matcher_for(coll, pattern)
      matcher = proc do |pattern|
        send(coll).select! { |element| element.send(:matches?, pattern) }
      end
      self.class.send(:define_method, "match_#{coll}_by", matcher)
    end

    def method_missing(method, *args, &block)
      if method.to_s.start_with?('match_')
        coll = method.to_s.match(/(?<=match_)(.*)(?=_by)/)[0].to_sym
        matcher_for(coll, *args[0])
        __send__(method, *args, &block)
      else
        super
      end
    end
  end
end
