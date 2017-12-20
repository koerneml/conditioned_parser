module ConditionedParser
  # Enables template definition in dsl style
  class Template
    attr_accessor :regions

    def initialize
      @regions = []
    end

    def region(identifier, &block)
      region = Region.new(identifier)
      region.instance_eval(&block) if block_given?
      region.define_box
      @regions << region
    end
  end
end
