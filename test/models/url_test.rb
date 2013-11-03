require 'test_helper'

class UrlTest < ActiveSupport::TestCase
	setup do
		@url = Url.new(:url => "www.google.com")
	end

  test "create url" do
    assert @url.valid?
    assert Url.create(:url => 'yahoo.com')
  end

  test "url required" do
  	@url.url = ''
  	assert !@url.valid?, 'Url must not be blank'
    assert @url.errors.full_messages_for(:url).include? "Url can't be blank"
  end

  test "view url from database" do
  	@url.save
    assert Url.find_by_url('www.google.com')
	end

	test "view url which is not in database" do
		url = Url.find_by_url('www.wikipedia.org')
		assert url.nil?
	end
end
