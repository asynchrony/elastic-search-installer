module GLI
  # Indicates that the command line invocation was bad
  class BadCommandLine < Exception
    def exit_code; -1; end
  end

  # Indicates the bad command line was an unknown command
  class UnknownCommand < BadCommandLine
  end

  # Indicates the bad command line was an unknown global argument
  class UnknownGlobalArgument < BadCommandLine
  end

  # Indicates the bad command line was an unknown command argument
  class UnknownCommandArgument < BadCommandLine
    attr_reader :command
    # +message+:: the error message to show the user
    # +command+:: the command we were using to parse command-specific options
    def initialize(message,command)
      super(message)
      @command = command
    end
  end

  # Raise this if you want to use an exit status that isn't the default
  # provided by GLI.  Note that GLI#exit_now! might be a bit more to your liking.
  #
  # Example:
  #
  #     raise CustomExit.new("Not connected to DB",-5) unless connected?
  #     raise CustomExit.new("Bad SQL",-6) unless valid_sql?(args[0])
  #
  class CustomExit < Exception
    attr_reader :exit_code #:nodoc:
    # Create a custom exit exception
    #
    # +message+:: String containing error message to show the user
    # +exit_code+:: the exit code to use (as an Int), overridding GLI's default
    def initialize(message,exit_code)
      super(message)
      @exit_code = exit_code
    end
  end
end
