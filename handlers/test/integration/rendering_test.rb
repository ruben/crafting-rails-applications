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

  test ".merb dual template" do
    email = Notifier.contact("your@example.com")

    assert_equal 2, email.parts.size
    assert_equal "multipart/alternative", email.mime_type

    assert_equal "text/plain", email.parts[0].mime_type
    assert_equal "Dual templates **rock**!", email.parts[0].body.encoded.strip

    assert_equal "text/html", email.parts[1].mime_type
    assert_equal "<p>Dual templates <strong>rock</strong>!</p>", email.parts[1].body.encoded.strip

  end

end