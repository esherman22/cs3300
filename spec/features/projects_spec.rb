require 'rails_helper'

RSpec.configure do |config|
  config.include Devise::Test::IntegrationHelpers, type: :feature
end

RSpec.feature "Projects", type: :feature do
  context "Create new project" do

    before(:each) do
      User.create!(email: "testuser22@testuser.com", password: "testuser")
      visit "/users/sign_in"

      fill_in "Email", with: "testuser22@testuser.com"
      fill_in "Password", with: "testuser"
      
      click_button "Log in"
      visit new_project_path
      within("form") do
        fill_in "Title", with: "Test title"
      end
    end

    scenario "should be successful" do
      fill_in "Description", with: "Test description"
      click_button "Create Project"
      expect(page).to have_content("Project")
    end

    scenario "should fail" do
      click_button "Create Project"
      expect(page).to have_content("Description can't be blank")
    end
  end

  context "Update project" do
    let(:project) { Project.create(title: "Test title", description: "Test content") }
    before(:each) do
      User.create!(email: "testuser22@testuser.com", password: "testuser")
      visit "/users/sign_in"

      fill_in "Email", with: "testuser22@testuser.com"
      fill_in "Password", with: "testuser"

      click_button "Log in"
      visit edit_project_path(project)
    end

    scenario "should be successful" do
      within("form") do
        fill_in "Description", with: "New description content"
      end
      click_button "Update Project"
      expect(page).to have_content("Project")
    end

    scenario "should fail" do
      within("form") do
        fill_in "Description", with: ""
      end
      click_button "Update Project"
      expect(page).to have_content("Description can't be blank")
    end
  end

  context "Remove existing project" do
    let!(:project) { Project.create(title: "Test title", description: "Test content") }
    before(:each) do
      User.create!(email: "testuser22@testuser.com", password: "testuser")
      visit "/users/sign_in"

      fill_in "Email", with: "testuser22@testuser.com"
      fill_in "Password", with: "testuser"
      
      click_button "Log in"
    end
    
    scenario "remove project" do
     
      visit projects_path
      click_link "Destroy"
      expect(page).to have_content("Project")
      expect(Project.count).to eq(0)
    end
  end

end
