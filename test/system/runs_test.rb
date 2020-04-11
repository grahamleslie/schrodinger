require "application_system_test_case"

class RunsTest < ApplicationSystemTestCase
  setup do
    @run = runs(:one)
  end

  test "visiting the index" do
    visit runs_url
    assert_selector "h1", text: "Runs"
  end

  test "creating a Run" do
    visit runs_url
    click_on "New Run"

    fill_in "Completed at", with: @run.completed_at
    fill_in "Datetime,", with: @run.datetime,
    fill_in "Failed at", with: @run.failed_at
    fill_in "Num", with: @run.num
    fill_in "Output", with: @run.output
    fill_in "String", with: @run.string
    click_on "Create Run"

    assert_text "Run was successfully created"
    click_on "Back"
  end

  test "updating a Run" do
    visit runs_url
    click_on "Edit", match: :first

    fill_in "Completed at", with: @run.completed_at
    fill_in "Datetime,", with: @run.datetime,
    fill_in "Failed at", with: @run.failed_at
    fill_in "Num", with: @run.num
    fill_in "Output", with: @run.output
    fill_in "String", with: @run.string
    click_on "Update Run"

    assert_text "Run was successfully updated"
    click_on "Back"
  end

  test "destroying a Run" do
    visit runs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Run was successfully destroyed"
  end
end
