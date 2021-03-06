require 'rails_helper'

feature "profile management" do
  let(:member) { FactoryGirl.create(:member) }
  before do
    login_as(member, :scope => :member)
  end
  
  def fill_in_fields
      fill_in "First Name", with: "Joe"
      fill_in "Last Name", with: "Doe"
      fill_in "Address", with: "main street 36"
      fill_in "City", with: "New York"
      fill_in "Postal Code", with: 9000
      fill_in "State", with: "NY"
      select "2016", from: "profile[birthday(1i)]"
      select "May", from: "profile[birthday(2i)]"
      select "21", from: "profile[birthday(3i)]"
      fill_in "Credit Card Number", with: "12345678"
      fill_in "Bio", with: "a programmer living in Ghent"
      profile_pic_path = 'spec/fixtures/files/profile_pic.jpg'
      check "Is host"
      attach_file "profile[profile_pic]", profile_pic_path
  end

  context "with valid data" do
    scenario "member creates profile" do
      visit root_path
      click_link "Create Profile"
      fill_in_fields
      click_button "Create Profile"
      expect(page).to have_content("Successfully created profile.")
      profile = Profile.last
      expect(current_path).to eq member_profile_path(member, profile)
      expect(profile).to have_attributes(profile_pic_file_name: a_value)
      expect(profile.is_host).to be true
    end
    scenario "member edits profile" do
      profile = FactoryGirl.create(:profile)
      profile.member_id = member.id
      profile.save
      visit root_path
      click_link "Profile"
      click_button "Edit Profile"
      fill_in_fields
      click_button "Update Profile"
      expect(page).to have_content("Successfully updated profile.")
      expect(current_path).to eq member_profile_path(member, profile)
      expect(page).to have_content "Joe"
      expect(page).to have_content "Doe"
      expect(page).to have_content "a programmer living in Ghent"
    end
  end

  context "with invalid data" do
    scenario "member creates profile" do
      visit root_path
      click_link "Create Profile"
      fill_in "First Name", with: ""
      fill_in "Last Name", with: ""
      fill_in "Address", with: "main street 36"
      fill_in "City", with: "New York"
      fill_in "Postal Code", with: 9000
      fill_in "State", with: "NY"
      select "2016", from: "profile[birthday(1i)]"
      select "May", from: "profile[birthday(2i)]"
      select "21", from: "profile[birthday(3i)]"
      fill_in "Credit Card Number", with: "12345678"
      click_button "Create Profile"
      expect(page).to have_content("Could not create profile.")
    end

    scenario "member edits profile" do
      profile = FactoryGirl.create(:profile)
      profile.member_id = member.id
      profile.save
      visit root_path
      click_link "Profile"
      click_button "Edit Profile"
      fill_in "First Name", with: ""
      fill_in "Last Name", with: "Doe"
      click_button "Update Profile"
      expect(page).to have_content("Could not update profile.")
      expect(current_path).to eq member_profile_path(member, profile)
      expect(profile.first_name).not_to eq ""
      expect(profile.last_name).not_to eq "Doe"
    end
  end
end
