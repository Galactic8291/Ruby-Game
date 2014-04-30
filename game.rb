require 'rubygems'
require 'rubygame'
require './conf.rb'
require './shared.rb'
require './pause.rb'
require './about.rb'
require './options.rb'
require './title.rb'
require './ingame.rb'
Rubygame::TTF.setup
 
class Game
    attr_accessor :screen, :queue, :clock, :state
    def initialize
        @screen = Rubygame::Screen.new [640, 480], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
        @screen.title = "Pong"
        @queue = Rubygame::EventQueue.new

        @clock = Rubygame::Clock.new
        @clock.target_framerate = 60
        @state = nil
        @state_buffer = nil
    end

    def run!
        loop do
            update
            draw
            @clock.tick
        end
    end

    def update
        @queue.peek_each do |ev|
            case ev
                when Rubygame::QuitEvent
                    Rubygame.quit
                    exit
                when Rubygame::KeyDownEvent
                    if ev.key == Rubygame::K_ESCAPE and @state.class == Title
                        @queue.push Rubygame::QuitEvent.new
                    end
            end
        end
        @state.update
        if @state_buffer != nil
            @state = @state_buffer
            @state_buffer = nil

        end
    end

    def draw
        @state.draw 
    end

    def switch_state state
        if @state != nil
            @state.state_change(:going_out)
            @state_buffer = state
        else
            @state = state
        end
        state.state_change(:going_in)
    end
end

g = Game.new
g.switch_state Title.new(g)
g.run!