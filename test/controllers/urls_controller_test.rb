require 'test_helper'

class UrlsControllerTest < ActionController::TestCase
  setup do
    @url = Url.new(:url => "www.abc.com", :key => "12f")
  end

  test "should get index" do
    get :index
    assert_response :success
    get :new
    assert_response :success
  end

  test "should create url" do
    assert_difference('Url.count') do
      post :create, url: { key: @url.key, url: @url.url }
    end

    assert_redirected_to url_path(assigns(:url))
  end

  test "Cannot create url with empty url" do
    @url.url = ""
    assert_difference('Url.count', 0) do
      post :create, url: { key: @url.key, url: @url.url }
    end
  end

  test "should show url" do
    get :show, id: urls(:one)
    assert_response :success
  end

  test "shorten url with generated key" do
    @url.key = ""
    assert_difference('Url.count') do
      post :create, url: {url: @url.url, key: @url.key}
    end

    assert_redirected_to url_path(assigns(:url))
    assert !Url.find_by_url("www.abc.com").key.nil?
  end 

  test "Duplicate urls should not generate a new key" do
    url = Url.new(:url => "www.google.com", :key => "")

    assert_difference('Url.count', 0) do
      post :create, url: { key: url.key, url: url.url }
    end
  end

  test "Save a new url with an optional key" do
    assert_difference('Url.count') do
      post :create, url: { key: @url.key, url: @url.url }
    end

    assert Url.find_by_key("abc")
  end

  test "Save an existing url with optional key" do
    @url.url = Url.find_by_id(urls(:one)).url
    assert_difference('Url.count') do
      post :create, url: { key: @url.key, url: @url.url }
    end

    assert_equal("www.google.com", Url.find_by_key("12f").url, "Cannot save an existing url with a new optional key")
  end

  test "redirect to url" do
    get :redirect, key: "abc"
    assert_response :redirect
  end

  test "optional key should be unique" do
    @url.key = Url.find_by_id(urls(:one)).key
    assert_difference('Url.count', 0) do
      post :create, url: { key: @url.key, url: @url.url }
    end
  end
end
