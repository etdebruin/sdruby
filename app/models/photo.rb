# == Schema Information
#
# Table name: photos
#
#  id         :integer          not null, primary key
#  url        :text
#  caption    :text
#  created_at :datetime
#  updated_at :datetime
#

class Photo < ActiveRecord::Base
  #attr_accessor :url, :caption

end
