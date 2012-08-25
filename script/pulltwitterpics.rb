require 'twitter'
require 'pp'


module TwitterPics
  class << self
    attr_accessor :user

    def pull
      timeline = Twitter.media_timeline(@user)

      timeline.each do |t|
        status = Twitter::Client.new.status(t.id, {:include_entities => true})
        # pp status

        p status.text
        p status.created_at
        status.media.each do |m|
          p m.media_url
        end
      end
    end
  end
end

TwitterPics.user = 'etdebruin'
TwitterPics.pull
