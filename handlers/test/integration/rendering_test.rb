class RenderingTest < ActionDispatch::IntegrationTest
  test ".rb template handler" do
    get "/handlers/rb_handler"
    assert_match "This is my first <b>template handler</b>!", response.body
  end

  test ".string template handler" do
    get "/handlers/string_handler"
    assert_match "Congratulations! You just created another template handler!", response.body
  end

  test ".md template handler" do
    get "handlers/markdown_handler"
    assert_match "<p>RDiscount is <em>cool</em> and <strong>fast</strong>!</p>", response.body
    end

  test ".merb template handler" do
    get "handlers/merb_handler"
    assert_match "MERB template handler is <strong>cool and fast</strong>", response.body
  end

end