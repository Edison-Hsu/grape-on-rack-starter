# == Schema Information
#
# Table name: social_accounts
#
#  id         :uuid             not null, primary key
#  user_id    :uuid
#  identifier :string           not null
#  type       :string(128)      not null
#  raw        :jsonb
#  deleted_at :datetime
#  created_at :datetime
#  updated_at :datetime
#

class SocialAccount < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
end
