require 'test_helper'

class RespondersTest < ActionController::TestCase
  tests UsersController


  test "Sets notice message on user creation" do
    post :create, user: {name: 'John Doe'}
    assert_equal "User was successfully created", flash[:notice]
  end

  test "Sets alert messages from the controller scope" do
   begin
     I18n.backend.store_translations :en,
     { flash: { users: { destroy: { alert: "Cannot destroy!"} } } }

      user = User.create!(name: "Undestroyable")
      delete :destroy, id: user.id
      assert_equal "Cannot destroy!", flash[:alert]

   ensure
     I18n.reload!
   end
  end
end
