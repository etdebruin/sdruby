#
# This script is meant to be run using 'rails runner script/pulltwitterpics.rb'
# which pulls as many pictures from twitter as they will send us and write urls
# to the database using the Photo model.
#
# Author: Etienne de Bruin <etdebruin@gmail.com>
# Date: 9/1/2012
#
# i <3 sdruby
#

require 'twitter'

module TwitterPics
  class << self
    attr_accessor :user

    def pull
      timeline = Twitter.media_timeline(@user)

      last_photo = Photo.find(:first, :conditions => { :twitter_user => @user }, :order => "status_create_date DESC")

      timeline.each do |t|
        status = Twitter::Client.new.status(t.id, {:include_entities => true})

        break if status.id == last_photo.status_id unless last_photo.nil?

        status.media.each do |m|
          photo = Photo.new
          photo.twitter_user = @user
          photo.url = m.media_url
          photo.caption = status.text
          photo.status_id = status.id
          photo.status_create_date = status.created_at
          photo.save
        end
      end
    end
  end
end

TwitterPics.user = 'sdruby'
TwitterPics.pull
