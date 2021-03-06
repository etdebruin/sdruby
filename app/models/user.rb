# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  full_name             :string(255)
#  email                 :string(255)
#  type                  :string(255)
#  about                 :text
#  links                 :text
#  avatar_file_name      :string(255)
#  avatar_content_type   :string(255)
#  avatar_file_size      :integer
#  crypted_password      :string(255)      not null
#  password_salt         :string(255)      not null
#  persistence_token     :string(255)      not null
#  single_access_token   :string(255)      not null
#  perishable_token      :string(255)      not null
#  login_count           :integer          default(0), not null
#  failed_login_count    :integer          default(0), not null
#  created_at            :datetime
#  updated_at            :datetime
#  github_username       :string(255)
#  started_using_ruby_on :date
#  neighborhood          :string(255)
#  available_for_work    :boolean
#  show_email            :boolean          default(FALSE)
#  admin                 :boolean          default(FALSE)
#  role                  :string(255)
#  sort                  :integer          default(0)
#

require 'net/http'
require "open-uri"

class User < ActiveRecord::Base
  has_many :projects, :order => "github_created_at DESC"

  acts_as_authentic

  validates :full_name, :length => { :minimum => 2 }
  validates :email, :uniqueness => true, :format => { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  validate :avatar_is_valid

  has_attached_file :avatar, 
                    :styles => { :small  => "48x48#", :medium  => "128x128#", :large  => "256x256#" }, 
                    :path => ":rails_root/public/images/users/avatars/:id/:style.:extension",
                    :url => "/images/users/avatars/:id/:style.:extension",
                    :default_url => "/images/users/avatar_:style.png"
               
  def to_s
    full_name
  end
         
  def is_admin?
    self.id == 1 ? true : false
  end

  def first_name
    full_name.split(' ').first
  end

  def last_name
    full_name.split(' ')[1..-1].join(" ")
  end

  def grab_projects
    unless self.github_username.blank?
      # Destroy existing projects
      self.projects.destroy_all
      
      # Grab new projects
      begin
        api_uri = URI("https://api.github.com/users/#{self.github_username.strip}/repos")
        api_session = Net::HTTP.new api_uri.host, api_uri.port
        api_session.use_ssl = true

        repos = JSON.parse(api_session.request(Net::HTTP::Get.new(api_uri.request_uri)).body)
        repos.each do |repo|
          next if repo['fork']
          self.projects << Project.create( :name            => repo['name'],
                                        :description        => repo['description'],
                                        :github_created_at  => repo['created_at'],
                                        :github_pushed_at   => repo['pushed_at'],
                                        :github_watchers    => repo['watchers'] )
        end
      rescue Exception => e#if no projects are found
        Rails.logger.error(e.inspect)
      end
    else
      # Destroy existing projects (if github username is blank)
      self.projects.destroy_all
    end
  end

  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save

    UserMailer.forgot_password(self.email, new_pass).deliver
  end

  def twitter
    handle = nil
    if self.links
      self.links.split("\n").each do |link|
        if link.match('twitter')
          handle = link.split(/\//)[-1]
        end
      end
      if handle != nil
        return handle
      else
        return false
      end
    else
      return false
    end
  end

  protected
  
  def avatar_is_valid
    if self.avatar_file_name?
      unless ["image/gif", "image/jpeg", "image/png"].include?(self.avatar_content_type)
        errors.add_to_base "Avatar must be a GIF, JPEG, or PNG"
      end
    end
  end

  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
  
end
