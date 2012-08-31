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

require "spec_helper"

describe Event do
  before { @event = FactoryGirl.create(:event) }

  it "should be valid" do
    @event.should be_valid
  end

  context "with two upcoming events" do
    before do
      Event.destroy_all

      @old_event = FactoryGirl.create(:event, :starts_at => 3.days.ago, :ends_at => 2.days.ago)
      @first_event = FactoryGirl.create(:event, :starts_at => 1.day.from_now, :ends_at => 2.days.from_now)
      @second_event = FactoryGirl.create(:event, :starts_at => 3.days.from_now, :ends_at => 4.days.from_now)
    end

    describe "next event" do
      before { @next_event = described_class.next }

      it "should be the first upcoming event" do
        @next_event.should == @first_event
      end
    end
  end
end
