class RenderingTest < ActionDispatch::IntegrationTest
  test ".rb template handler" do
    get "/handlers/rb_handler"
    assert_match "This is my first <b>template handler</b>!", response.body
  end
end