require 'rnmap/output_formatter'

module Rnmap
  class Task
    def initialize(address)
      @address = address
    end

    def generate_nmap_command
      "nmap -v0 -oX #{@address.to_filename} #{@address.to_s}"
    end

    def previous_output_file_exist?
      File.file?(@address.to_filename)
    end

    def run_scan(command)
      Kernel.system(command)
    end

    def parse_previous_output
      previous_output = {}
      if previous_output_file_exist?
        previous_output = OutputFormatter.parse(@address.to_filename)
      end
      previous_output
    end

    def run_nmap
      previous_output = parse_previous_output
      run_scan(generate_nmap_command)
      output = OutputFormatter.new(@address.to_filename, previous_output)
      output.print_formatted_output
    end
  end
end
