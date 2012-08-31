# == Schema Information
#
# Table name: podcasts
#
#  id                      :integer          not null, primary key
#  name                    :string(255)
#  description             :text
#  movie_link              :string(255)
#  publish                 :boolean
#  created_at              :datetime
#  updated_at              :datetime
#  old_permalink           :string(255)
#  screenshot_file_name    :string(255)
#  screenshot_content_type :string(255)
#  screenshot_file_size    :integer
#  screenshot_updated_at   :datetime
#  movie_duration          :string(255)
#  movie_size              :integer
#

require 'spec_helper'

describe Podcast do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:movie_link) }
end
