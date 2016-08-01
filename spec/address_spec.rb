require 'spec_helper'
require 'rnmap/address'

describe Address do
  describe "#ipaddr" do
    let(:ipaddr) { '127.0.0.1' }
    subject { described_class.new(ipaddr) }

    context "when @ipaddr is already set" do
      it 'should return the already set value' do
        subject.instance_variable_set(:@ipaddr, 'ipaddr')
        expect(subject.ipaddr).to eq('ipaddr')
      end
    end
    context "when @ipaddr is not set" do
      context "when host_or_url is a valid ipaddr" do
        it 'should return the valid ipaddr' do
          subject.instance_variable_set(:@ipaddr, nil)
          expect(subject.ipaddr).to eq('127.0.0.1')
        end
      end
      context "when host_or_url is not a valid ipaddr" do
        it 'should return nil' do
          subject.instance_variable_set(:@ipaddr, nil)
          subject.instance_variable_set(:@host_or_url, 'invalid ipaddr')
          expect(subject.ipaddr).to be_nil
        end
      end
    end
  end

  describe "#hostname" do
    let(:url) { 'http://hostname.com' }
    subject { described_class.new(url) }

    context "when @hostname is already set" do
      it 'should return the already set value' do
        subject.instance_variable_set(:@hostname, 'hostname')
        expect(subject.hostname).to eq('hostname')
      end
    end
    context "when @hostname is not set" do
      context "when host_or_url has a valid hostname" do
        it 'should return the valid hostname' do
          subject.instance_variable_set(:@hostname, nil)
          expect(subject.hostname).to eq('hostname.com')
        end
      end
      context "when host_or_url has not a valid hostname" do
        it 'should return nil' do
          subject.instance_variable_set(:@hostname, nil)
          subject.instance_variable_set(:@host_or_url, 'invalid hostname')
          expect(subject.hostname).to be_nil
        end
      end
    end
  end

  describe "#is_valid" do
    let(:host_or_url) { 'http://hostname.com' }
    subject { described_class.new(host_or_url) }

    context "when ipaddr is valid" do
      it "should return true" do
        subject.instance_variable_set(:@ipaddr, '127.0.0.1')
        expect(subject.is_valid?).to be_truthy
      end
    end
    context "when hostname is valid" do
      it "should return true" do
        subject.instance_variable_set(:@hostname, 'hostname.com')
        expect(subject.is_valid?).to be_truthy
      end
    end
    context "when ipaddr and hostname are invalid" do
      it "should return false" do
        subject.instance_variable_set(:@hostname, false)
        subject.instance_variable_set(:@ipaddr, false)
        expect(subject.is_valid?).to be_falsey
      end
    end
  end

  describe "#is_valid" do
    let(:host_or_url) { 'http://app.hostname.com' }
    subject { described_class.new(host_or_url) }

    context "when host_or_url is a hostname" do
      it "should return the file name based on the hostname" do
        expect(subject.to_filename).to eq('app-hostname-com.xml')
      end
    end
    context "when host_or_url is an IP address" do
      it "should return the file name based on the IP address" do
        subject.instance_variable_set(:@host_or_url, '127.0.0.1')
        expect(subject.to_filename).to eq('127-0-0-1.xml')
      end
    end
  end

  describe "#to_s" do
    let(:addr) { '127.0.0.1' }
    subject { described_class.new(addr) }

    context "when is_valid? is true" do
      it "should return the address" do
        subject.instance_variable_set(:@host, '127.0.0.1')
        allow(subject).to receive(:is_valid?) { true }
        expect(subject.to_s).to eq(addr)
      end
    end
    context "when is_valid? is false" do
      it "should return the address" do
        allow(subject).to receive(:is_valid?) { false }
        expect(subject.to_s).to be_nil
      end
    end
  end
end
