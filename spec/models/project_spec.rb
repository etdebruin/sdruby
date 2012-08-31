# == Schema Information
#
# Table name: projects
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  description       :text
#  user_id           :integer
#  created_at        :datetime
#  updated_at        :datetime
#  github_created_at :datetime
#  github_pushed_at  :datetime
#  github_watchers   :integer
#

require 'spec_helper'

describe Project do
  it { should belong_to(:user) }
  it { should validate_presence_of(:name) }

  it "should be valid" do
    @project = FactoryGirl.build(:project)
    @project.should be_valid
  end

  describe "featured" do

    it "should return a project with 5 or more watchers" do
      @project = FactoryGirl.create(:project, :github_watchers => 6, :github_pushed_at => 1.month.ago)
      Project.featured.should eq(@project)
    end

    it "should not return a project with less than 5 watchers" do
      @project = FactoryGirl.create(:project, :github_watchers => 4)
      Project.featured.should be_nil
    end
  end
end
