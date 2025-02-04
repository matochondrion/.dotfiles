begin
  require 'awesome_print'
  Pry.config.print = proc { |output, value| output.puts value.ai }
rescue LoadError
  puts 'no awesome_print :('
end

begin
  require 'hirb'
rescue LoadError
  # puts ".pryrc: hirb not installed (try 'gem install hirb')"
end

# from https://github.com/pry/pry/wiki/FAQ#awesome_print
if defined? Hirb
  # Slightly dirty hack to fully support in-session Hirb.disable/enable toggling
  Hirb::View.instance_eval do
    def enable_output_method
      @output_method = true
      @old_print = Pry.config.print
      Pry.config.print = proc do |*args|
        Hirb::View.view_or_page_output(args[1]) || @old_print.call(*args)
      end
    end

    def disable_output_method
      Pry.config.print = @old_print
      @output_method = nil
    end
  end

  Hirb.enable
end

# Copy ruby value to pbcopy on mac:
# https://inspirnathan.com/posts/9-copy-to-clipboard-in-ruby/
# obj = {a: "Hello World!", b: "Hi Earth!"}
# IO.popen('pbcopy', 'w') { |pipe| pipe.puts obj }

def pbcopy(obj)
   IO.popen('pbcopy', 'w') { |pipe| pipe.puts obj }
end
