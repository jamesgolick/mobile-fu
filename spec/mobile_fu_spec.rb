require File.expand_path("../spec_helper", __FILE__)

class FakeController
  attr_accessor :request

  include ActionController::MobileFu

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
    @controller.request = Request.new("Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420+ (KHTML, like Gecko) Version/3.0 Mobile/1A543a Safari/419.3")
  end

  it "correctly extracts the operating system" do
    @controller.mobile_device_info.operating_system.should == :iphone
  end

  it "correctly extracts the OS version" do
    @controller.mobile_device_info.version.should == 3.0
  end
end
