module ConditionedParser
  # Region definition in dsl style
  # A complete region is specified via defining a box in 3 possible variations:
  # 1) Giving all outer distances of the box to the page borders
  # 2) Giving an absolute starting point, height, and width of the box
  # 3) Giving two absolute point coordinates defining the box
  class Region
    include Model::Box
    attr_reader :identifier

    def initialize(identifier)
      @identifier = identifier
    end

    BOX_LENGTHS = %w[height width].freeze
    OUTER_BORDERS = %w[left right upper lower].freeze
    POINT_DEFINITIONS = %w[start end].freeze

    BOX_LENGTHS.each do |l|
      define_method("has_#{l}".to_sym) do |value|
        instance_variable_set("@#{l}".to_sym, value)
      end
    end

    OUTER_BORDERS.each do |outer|
      define_method("distance_to_#{outer}".to_sym) do |value|
        instance_variable_set("@#{outer}_dist".to_sym, value)
      end
    end

    POINT_DEFINITIONS.each do |d|
      define_method("#{d}s_at_point".to_sym) do |x, y|
        instance_variable_set("@x_#{d}".to_sym, x)
        instance_variable_set("@y_#{d}".to_sym, y)
      end
    end

    def define_box
      if size_based_definition?
        define_size_box
      elsif point_based_definition?
        return
      else
        raise 'Incomplete or inconsistent region definition'
      end
    end

    def legal_region_definition?
      dist_based_definition? || size_based_definition? || point_based_definition?
    end

    private

    def dist_based_definition?
      @left_dist && @lower_dist && @right_dist && @upper_dist
    end

    def size_based_definition?
      x_start && y_start && @height && @width
    end

    def point_based_definition?
      x_start && x_end && y_start && y_end
    end

    def define_dist_box(page)
      x_start = @left_dist + page.x_start,
      x_end = page.x_end - @right_dist,
      y_start = @upper_dist + page.y_start,
      y_end = page.y_end - @lower_dist
    end

    def define_size_box
      x_end = x_start + @width,
      y_end = y_start + @height
    end
  end
end
