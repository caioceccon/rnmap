require 'spec_helper'
require 'rnmap/task'
require 'rnmap/address'

describe Task do
  let(:address) { instance_double("Address", :host_or_url => 'hostname.com') }
  subject { described_class.new(address) }

  describe "#generate_nmap_command" do
    it 'should generate the nmap command based on the address object' do
      allow(address).to receive(:to_filename) { 'test-addr-com.xml' }
      allow(address).to receive(:to_s) { 'test.addr.com' }
      expect(subject.generate_nmap_command).to eq(
        'nmap -v0 -oX test-addr-com.xml test.addr.com'
      )
    end
  end

  describe "#previous_ouput_file_exist?" do
    context "when previous output file exist" do
      it "should return true" do
        allow(address).to receive(:to_filename) { 'test-addr-com.xml' }
        allow(File).to receive(:file?).with('test-addr-com.xml') { true }
        expect(subject.previous_output_file_exist?).to be_truthy
      end
    end
    context "when previous output file does NOT exist" do
      it "should return false" do
        allow(address).to receive(:to_filename) { 'test-addr-com.xml' }
        allow(File).to receive(:file?).with('test-addr-com.xml') { false }
        expect(subject.previous_output_file_exist?).to be_falsey
      end
    end
  end

  describe "#run_scan" do
    it "should run a system call with the received command" do
      expect(Kernel).to receive(:system).with('test_command')
      subject.run_scan('test_command')
    end
  end

  describe "#parse_previous_output" do
    context "when previous output file exist" do
      it 'returns the parsed content' do
        allow(address).to receive(:to_filename) { 'test-addr-com.xml' }
        allow(subject).to receive(:previous_output_file_exist?) { true }
        allow(OutputFormatter).to receive(:parse) { 'parsed content' }

        expect(subject.parse_previous_output).to eq('parsed content')
      end
    end
  end

  describe "#run_nmap" do
    it "checks for previous output files" do
      allow(address).to receive(:to_filename) { 'test-addr-com.xml' }
      output_formatter_instance = double(OutputFormatter)
      allow(output_formatter_instance).to receive(:print_formatted_output)
      allow(OutputFormatter).to receive(:new) { output_formatter_instance }
      allow(OutputFormatter).to receive(:print_formatted_output)
      expect(subject).to receive(:parse_previous_output)
      subject.run_nmap
    end
    it "executes the run_scan with the right command" do
      allow(address).to receive(:to_filename) { 'test-addr-com.xml' }
      allow(subject).to receive(:generate_nmap_command) { 'command' }
      expect(subject).to receive(:run_scan).with('command')
      subject.run_nmap
    end
    it "call print_formatted_output on the OutputFormatter instance" do
      allow(address).to receive(:to_filename) { 'test-addr-com.xml' }
      output_formatter_instance = double(OutputFormatter)
      allow(OutputFormatter).to receive(:new) { output_formatter_instance }
      allow(output_formatter_instance).to receive(:print_formatted_output)
      expect(output_formatter_instance).to receive(:print_formatted_output)
      subject.run_nmap
    end
  end
end

