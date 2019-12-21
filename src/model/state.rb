# frozen_string_literal: true

# Model Module
module Model
  module Direction
    UP = :up
    DOWN = :down
    LEFT = :left
    RIGHT = :right
  end

  class Coord < Struct.new(:row, :col)
  end

  class Food < Coord
  end

  class Snake < Struct.new(:positions)
  end

  class Grid < Struct.new(:rows, :cols)
  end

  class State < Struct.new(
    :snake, :food, :grid,
    :current_direction, :speed, :game_finished
  )
  end

  def self.initial_state
    Model::State.new(
      Model::Snake.new([Model::Coord.new(1, 1),
                        Model::Coord.new(0, 1)]),
      Model::Food.new(4, 4),
      Model::Grid.new(12, 12),
      Direction::DOWN,
      0.5,
      false
    )
  end
end
