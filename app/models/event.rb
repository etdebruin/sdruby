# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  starts_at   :datetime
#  ends_at     :datetime
#  is_private  :boolean
#  created_at  :datetime
#  updated_at  :datetime
#  type        :string(255)      default("Event")
#

class Event < ActiveRecord::Base
  
  def self.types
    ['Event', 'Meeting']
  end
  
  def self.next
    self.find(:first, :conditions => ["starts_at > ? AND is_private = ?", Time.now, false ], :order => "starts_at ASC")
  end
  
end
