require_relative 'model/template'
require_relative 'model/region'

module ConditionedParser
  # builds a template from dsl-style region specification
  class TemplateBuilder
    def build_template(&block)
      @template = Model::Template.new
      block[self]
      @template
    end

    def define_region(identifier, &block)
      @region = Model::Region.new(identifier)
      block[self]
      @region.define_box
      @template.regions << @region
    end

    def starts_at_point(x, y)
      @region.x_start = x
      @region.y_start = y
    end

    def ends_at_point(x, y)
      @region.x_end = x
      @region.y_end = y
    end
  end
end
