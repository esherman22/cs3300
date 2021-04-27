class Project < ApplicationRecord
 extend FriendlyId
 friendly_id :title, use: :slugged
 validates_presence_of :title, :description

 def should_generate_new_friendly_id?
   title_changed?
 end

end
