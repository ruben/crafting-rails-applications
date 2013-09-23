class RenderingTest < ActionDispatch::IntegrationTest
  test ".rb template handler" do
    get "/handlers/rb_handler"
    assert_match "This is my first <b>template handler</b>!", response.body
  end

  test ".string template handler" do
    get "/handlers/string_handler"
    assert_match "Congratulations! You just created another template handler!", response.body
  end
end