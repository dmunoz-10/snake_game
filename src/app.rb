# frozen_string_literal: true

require_relative 'view/ruby2d'
require_relative 'model/state'
require_relative 'actions/actions'

# App Class
class App
  def initialize
    @state = Model.initial_state
    @pause = false
  end

  def start
    @view = View::Ruby2dView.new(self)
    timer_thread = Thread.new { init_timer }
    @view.start(@state)
    timer_thread.join
  end

  def init_timer
    loop do
      next if @pause

      if @state.game_finished
        puts 'Game over'
        puts "Score: #{@state.snake.positions.size}"
        break
      end
      @state = Actions.move_snake(@state)
      @view.render(@state)
      sleep @state.speed
    end
  end

  def send_action(action, params)
    new_state = Actions.send(action, @state, params)
    return unless new_state.hash != @state

    @state = new_state
    @view.render(@state)
  end

  def pause
    @pause = @pause ? false : true
    @view.render_pause @pause
  end
end

app = App.new
app.start
