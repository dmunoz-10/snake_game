# frozen_string_literal: true

require 'ruby2d'

module View
  # Ruby2dView Class
  class Ruby2dView
    def initialize(app)
      @pixel_size = 50
      @app = app
      @pause = nil
    end

    def start(state)
      extend Ruby2D::DSL
      set(
        title: 'Snake Game',
        width: @pixel_size * state.grid.cols,
        height: @pixel_size * state.grid.rows
      )
      on :key_down do |event|
        handle_key_event(event)
      end
      show
    end

    def render(state)
      extend Ruby2D::DSL
      close if state.game_finished
      render_food(state)
      render_snake(state)
    end

    def render_pause(pause)
      if pause
        @pause = Text.new(
          'Pause',
          x: 380, y: 12,
          size: 70,
          color: 'blue'
        )
      else
        @pause.remove
        @pause = nil
      end
    end

    private

    def render_food(state)
      @food&.remove

      extend Ruby2D::DSL
      food = state.food
      @food = Square.new(
        x: food.col * @pixel_size,
        y: food.row * @pixel_size,
        size: @pixel_size,
        color: 'red'
      )
    end

    def render_snake(state)
      @snake_positions&.each(&:remove)

      extend Ruby2D::DSL
      snake = state.snake
      @snake_positions = snake.positions.each_with_index.map do |position, index|
        color = index == 0 ? 'olive' : 'green'
        Square.new(x: position.col * @pixel_size,
                   y: position.row * @pixel_size,
                   size: @pixel_size, color: color)
      end
    end

    def handle_key_event(event)
      case event.key
      when 'up'
        @app.send_action(:change_direction, Model::Direction::UP)
      when 'down'
        @app.send_action(:change_direction, Model::Direction::DOWN)
      when 'left'
        @app.send_action(:change_direction, Model::Direction::LEFT)
      when 'right'
        @app.send_action(:change_direction, Model::Direction::RIGHT)
      when 'p'
        @app.pause
      end
    end
  end
end
