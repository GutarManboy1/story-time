class Story < ApplicationRecord
  belongs_to :user_id
  belongs_to :prompt_template_id
end
