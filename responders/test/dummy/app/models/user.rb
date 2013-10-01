class User < ActiveRecord::Base
  before_destroy do
    if name == "Undestroyable"
      errors.add(:user, 'Is undestroyable')
      false
    end
  end
end
