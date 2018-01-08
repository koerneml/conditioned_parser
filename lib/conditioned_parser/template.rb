module ConditionedParser
  # Enables template definition in dsl style
  class Template
    attr_accessor :regions

    def initialize
      @regions = []
    end

    def define_region(identifier, &block)
      raise 'Block required for region definition!' unless block_given?
      region = Region.new(identifier).tap { |r| r.instance_exec(&block) }
      region.define_box
      @regions << region
    end
  end
end
