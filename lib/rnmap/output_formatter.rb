require 'rexml/document'

module Rnmap
  class  OutputFormatter

    include REXML

    def initialize(output_file, previous_open_ports={})
      @output_file         = output_file
      @previous_open_ports = previous_open_ports
    end

    def self.parse_port_node(port_node)
      return port_node.attributes['portid'], {
        name:     port_node.elements['service'].attributes['name'],
        protocol: port_node.attributes['protocol'],
        state:    port_node.elements['state'].attributes['state']      }
    end

    def self.parse(output_file)
      xmlfile = File.new(output_file)
      xmldoc  = Document.new(xmlfile)

      open_ports = {}
      xmldoc.elements.each("nmaprun/host/ports/port") do |e|
        port, content = parse_port_node(e)
        open_ports.store(port, content)
      end

      open_ports
    end

    def print_formatted_output
      current_open_ports = self.class.parse(@output_file)

      @previous_open_ports.each do |port, port_settings|
        if not current_open_ports.key?(port)
          puts "Previous open port #{port} was closed #{port_settings.to_s}"
        else
          puts "Port #{port} continues open #{port_settings.to_s}"
        end
      end

      current_open_ports.each do |port, port_settings|
        if not @previous_open_ports.key?(port)
          puts "New open port #{port} #{port_settings.to_s}"
        end
      end
    end
  end
end





