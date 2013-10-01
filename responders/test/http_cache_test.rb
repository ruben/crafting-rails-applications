require 'test_helper'

class HttpCacheTest < ActionController::TestCase
  tests UsersController

  setup do
    @request.accept = "application/json"
    ActionController::Base.perform_caching = true

    User.create(name: "First", updated_at: Time.utc(2008))
    User.create(name: "Second", updated_at: Time.utc(2009))
  end

  test "Responds with last modified using the latest timestamp" do
    get :index
    assert_equal Time.utc(2009).httpdate, @response.headers['Last-Modified']
    assert_match '"name":"First"', @response.body
    assert_equal 200, @response.status
  end

  test "Respond with not modified if the request is still fresh" do
    @request.env["HTTP_IF_MODIFIED_SINCE"] = Time.utc(2009).httpdate
    get :index
    assert @response.body.blank?
    assert_equal 304, @response.status
  end

  test "Respond with modified if the request is not fresh" do
    @request.env["HTTP_IF_MODIFIED_SINCE"] = Time.utc(2008).httpdate
    get :index
    assert_equal Time.utc(2009).httpdate, @response.headers['Last-Modified']
    assert_match '"name":"Second"', @response.body
    assert_equal 200, @response.status
  end

end