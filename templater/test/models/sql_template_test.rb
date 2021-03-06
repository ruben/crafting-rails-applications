require 'test_helper'

class SqlTemplateTest < ActiveSupport::TestCase

  test "resolver returns template with the saved body" do
    resolver = SqlTemplate::Resolver.instance
    details = { formats: [:html], locale: [:en], handlers: [:erb] }

    #1) Assert the resolver cannot find the template as the database is empty
    # find_all(name, prefix, partial, details)
    assert resolver.find_all('index', 'posts', false, details).empty?

    #2) Create the template in the database
    sql_template = SqlTemplate.create!(
        body: "<%= 'Hi from SqlTemplate!' %>",
        path: "posts/index",
        format: "html",
        locale: "en",
        handler: "erb",
        partial: "false")

    #3) Assert that the template can now be found
    template = resolver.find_all("index", "posts", false, details).first
    assert_kind_of ActionView::Template, template

    #4) Assert specific information about the found template
    assert_equal "<%= 'Hi from SqlTemplate!' %>", template.source
    assert_kind_of ActionView::Template::Handlers::ERB, template.handler
    assert_equal [:html], template.formats
    assert_equal "posts/index", template.virtual_path
    assert_match %r[SqlTemplate - \d+ - "posts/index"], template.identifier

  end

  test "sql template expires the cache on update" do
    cache_key = Object.new
    resolver = SqlTemplate::Resolver.instance
    details = { formats: [:html], locale: [:en], handlers: [:erb] }

    template =  resolver.find_all("create", "posts", false, details, cache_key ).first
    assert_equal "body",  template.source

    sql_template = sql_templates(:one)
    sql_template.update_attributes(body: "changed body")

    template =  resolver.find_all("create", "posts", false, details, cache_key ).first
    assert_equal "changed body", template.source
  end
end
