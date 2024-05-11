require "application_system_test_case"

class MealSuggestionsTest < ApplicationSystemTestCase
  setup do
    @meal_suggestion = meal_suggestions(:one)
  end

  test "visiting the index" do
    visit meal_suggestions_url
    assert_selector "h1", text: "Meal suggestions"
  end

  test "should create meal suggestion" do
    visit meal_suggestions_url
    click_on "New meal suggestion"

    fill_in "Request body", with: @meal_suggestion.request_body
    fill_in "Request metadata", with: @meal_suggestion.request_metadata
    fill_in "Response body", with: @meal_suggestion.response_body
    fill_in "Response metadata", with: @meal_suggestion.response_metadata
    fill_in "Status", with: @meal_suggestion.status
    click_on "Create Meal suggestion"

    assert_text "Meal suggestion was successfully created"
    click_on "Back"
  end

  test "should update Meal suggestion" do
    visit meal_suggestion_url(@meal_suggestion)
    click_on "Edit this meal suggestion", match: :first

    fill_in "Request body", with: @meal_suggestion.request_body
    fill_in "Request metadata", with: @meal_suggestion.request_metadata
    fill_in "Response body", with: @meal_suggestion.response_body
    fill_in "Response metadata", with: @meal_suggestion.response_metadata
    fill_in "Status", with: @meal_suggestion.status
    click_on "Update Meal suggestion"

    assert_text "Meal suggestion was successfully updated"
    click_on "Back"
  end

  test "should destroy Meal suggestion" do
    visit meal_suggestion_url(@meal_suggestion)
    click_on "Destroy this meal suggestion", match: :first

    assert_text "Meal suggestion was successfully destroyed"
  end
end
