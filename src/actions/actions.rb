# frozen_string_literal: true

# Actions Module
module Actions
  def self.move_snake(state)
    next_position = calc_next_position(state)
    if position_is_food?(state, next_position)
      state = grow_snake_to(state, next_position)
      generate_food(state)
    elsif position_is_valid?(state, next_position)
      move_snake_to(state, next_position)
    else
      end_game(state)
    end
  end

  def self.change_direction(state, direction)
    if next_direction_is_valid?(state, direction)
      state.current_direction = direction
    end
    state
  end

  private

  def self.calc_next_position(state)
    current_position = state.snake.positions.first
    case state.current_direction
    when Model::Direction::UP
      Model::Coord.new(current_position.row - 1, current_position.col)
    when Model::Direction::DOWN
      Model::Coord.new(current_position.row + 1, current_position.col)
    when Model::Direction::LEFT
      Model::Coord.new(current_position.row, current_position.col - 1)
    when Model::Direction::RIGHT
      Model::Coord.new(current_position.row, current_position.col + 1)
    end
  end

  def self.grow_snake_to(state, next_position)
    state.snake.positions = [next_position] + state.snake.positions
    state = increase_speed(state)
  end

  def self.increase_speed(state)
    state.speed -= 0.004
    state
  end

  def self.generate_food(state)
    loop do
      coord = Model::Coord.new(rand(state.grid.rows), rand(state.grid.cols))
      add = true
      state.snake.positions.each do |position|
        add = false if coord == position
      end
      next unless add

      new_food = Model::Food.new(coord.row, coord.col)
      state.food = new_food
      break
    end
    state
  end

  def self.position_is_food?(state, position)
    state.food.row == position.row && state.food.col == position.col
  end

  def self.position_is_valid?(state, position)
    is_invalid = (position.row >= state.grid.rows || position.row.negative?) ||
                 (position.col >= state.grid.cols || position.col.negative?)
    return false if is_invalid

    !state.snake.positions.include?(position)
  end

  def self.next_direction_is_valid?(state, direction)
    case state.current_direction
    when Model::Direction::UP
      return true if direction != Model::Direction::DOWN
    when Model::Direction::DOWN
      return true if direction != Model::Direction::UP
    when Model::Direction::LEFT
      return true if direction != Model::Direction::RIGHT
    when Model::Direction::RIGHT
      return true if direction != Model::Direction::LEFT
    end
    false
  end

  def self.move_snake_to(state, next_position)
    new_positions = [next_position] + state.snake.positions[0...-1]
    state.snake.positions = new_positions
    state
  end

  def self.end_game(state)
    state.game_finished = true
    state
  end
end
