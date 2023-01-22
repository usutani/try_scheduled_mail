class Member < ApplicationRecord
  def deactivated?
    !!deactivated_at
  end
end
