module App
  module Helper
    module Base
      def title(value = nil)
        @title = value if value
        @title ? "Sinatra Template - #{@title}" : 'Sinatra Template'
      end
      
      def cycle
        @cycle ||= %w{odd even}.cycle
      end
    end
  end
end
