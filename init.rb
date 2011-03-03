require File.dirname(__FILE__) + '/lib/mobile_fu_helper.rb'
require File.dirname(__FILE__) + '/lib/mobile_fu'

ActionView::Base.send(:include, MobileFuHelper)
