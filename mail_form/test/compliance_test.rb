require 'test_helper'
require 'fixtures/sample_mail'

class ComplianceTest < ActiveSupport::TestCase
  include ActiveModel::Lint::Tests

  def setup
    @model = SampleMail.new
  end

  test "SampleMail has conversion methods provided by ActiveModel" do
    assert_equal nil, @model.to_key
    assert_equal "sample_mails/sample_mail", @model.to_partial_path
  end

  test "model name exposes human and singular methods" do
    assert_equal "sample_mail", @model.class.model_name.singular
    assert_equal "Sample mail", @model.class.model_name.human
  end

  test "model_name.human uses I18n" do
    begin
      I18n.backend.store_translations :en,
                                      activemodel: { models: { sample_mail: "My Sample email" } }
      assert_equal "My Sample email", @model.class.model_name.human
    ensure
      I18n.reload!
    end
  end

end
