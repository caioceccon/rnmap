require 'optparse'
require 'rnmap/address'
require 'rnmap/task'


module Rnmap

  class Parser
    def self.parse(options)
      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: rnmap [options]"

        opts.on("-aADDRESS",
                "--address=ADDRESS",
                "ADDRESS to check for open ports") do |a|
          address = Address.new a

          unless address.is_valid?
            STDERR.puts "Error: Invalid IP Address or URL for `#{a}`"
            exit 1
          end

          task = Task.new(address)
          task.run_nmap
        end

        opts.on("-h", "--help", "Prints this help") do
          puts opts
          exit
        end
      end
      opt_parser.parse!(options)
    end
  end
end


