require File.expand_path("../spec_helper", __FILE__)

class FakeController
  attr_accessor :request

  include MobileFu

  def self.before_filter(*args); end
  def self.helper_method(*args); end
  has_mobile_fu
end

class Request < Struct.new(:user_agent)
end

describe "Android user agents" do
  before do
    @controller = FakeController.new
    @controller.request = Request.new("Mozilla/5.0 (Linux; U; Android 2.1; en-us; Nexus One Build/ERD62) AppleWebKit/530.17 (KHTML, like Gecko) Version/4.0 Mobile Safari/530.17 –Nexus")
  end

  it "correctly extracts the operating system" do
    @controller.mobile_device_info.operating_system.should == :android
  end

  it "correctly extracts the OS version" do
    @controller.mobile_device_info.version.should == 2.1
  end
end

describe "iPhone user agents" do
  before do
    @controller = FakeController.new
    @controller.request = Request.new("Mozilla/5.0 (iPhone; U; iPhone OS 4_2_1 like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3")
  end

  it "correctly extracts the operating system" do
    @controller.mobile_device_info.operating_system.should == :iphone
  end

  it "correctly extracts the OS version" do
    @controller.mobile_device_info.version.should == 4.2
  end
end

describe "Blackberry user agents" do
  before do
    @controller = FakeController.new
    @controller.request = Request.new("Mozilla/5.0 (BlackBerry; U; BlackBerry 9800; en-US) AppleWebKit/534.1+ (KHTML, like Gecko) Version/6.0.0.141 Mobile Safari/534.1+")
  end

  it "correctly extracts the operating system" do
    @controller.mobile_device_info.operating_system.should == :blackberry
  end

  it "correctly extracts the OS version" do
    @controller.mobile_device_info.version.should == 6.0
  end
end

describe "WebOS user agents" do
  before do
    @controller = FakeController.new
    @controller.request = Request.new("Mozilla/5.0 (webOS/1.1; U; en-US) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/1.0 Safari/525.27.1 Pre/1.0")
  end

  it "correctly extracts the operating system" do
    @controller.mobile_device_info.operating_system.should == :webos
  end

  it "correctly extracts the OS version" do
    @controller.mobile_device_info.version.should == 1.1
  end
end

describe "Unknown user agents" do
  before do
    @controller = FakeController.new
    @controller.request = Request.new("Mozilla/5.0 (fuckOS/1.1; U; en-US) AppleWebKit/525.27.1 (KHTML, like Gecko) Version/1.0 Safari/525.27.1 Pre/1.0")
  end

  it "sets an OS of unknown" do
    @controller.mobile_device_info.operating_system.should == :unknown
  end

  it "sets a version of nil" do
    @controller.mobile_device_info.version.should be_nil
  end
end

describe "Supported devices" do
  before do
    FakeController.supported_devices.clear
    FakeController.supported_devices[:iphone] = (4.0..10.0)
    @controller = FakeController.new
  end

  it "when the OS matches, but it's below the minimum" do
    @controller.request = Request.new("Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3")
    @controller.should_not be_is_mobile_device
  end

  it "when the OS matches, but it's above the maximum" do
    @controller.request = Request.new("Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/11.0 Mobile/1A543a Safari/419.3")
    @controller.should_not be_is_mobile_device
  end

  it "when the OS matches, but it's in the accepted range" do
    @controller.request = Request.new("Mozilla/5.0 (iPhone; U; iPhone OS 4_2_1 X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/4.0 Mobile/1A543a Safari/419.3")
    @controller.should be_is_mobile_device
  end
end
