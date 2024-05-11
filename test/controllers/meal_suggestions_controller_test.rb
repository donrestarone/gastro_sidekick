require "test_helper"

class MealSuggestionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @meal_suggestion = meal_suggestions(:one)
  end

  test "should get index" do
    get meal_suggestions_url
    assert_response :success
  end

  test "should get new" do
    get new_meal_suggestion_url
    assert_response :success
  end

  test "should create meal_suggestion" do
    assert_difference("MealSuggestion.count") do
      post meal_suggestions_url, params: { meal_suggestion: { request_body: @meal_suggestion.request_body, request_metadata: @meal_suggestion.request_metadata, response_body: @meal_suggestion.response_body, response_metadata: @meal_suggestion.response_metadata, status: @meal_suggestion.status } }
    end

    assert_redirected_to meal_suggestion_url(MealSuggestion.last)
  end

  test "should show meal_suggestion" do
    get meal_suggestion_url(@meal_suggestion)
    assert_response :success
  end

  test "should get edit" do
    get edit_meal_suggestion_url(@meal_suggestion)
    assert_response :success
  end

  test "should update meal_suggestion" do
    patch meal_suggestion_url(@meal_suggestion), params: { meal_suggestion: { request_body: @meal_suggestion.request_body, request_metadata: @meal_suggestion.request_metadata, response_body: @meal_suggestion.response_body, response_metadata: @meal_suggestion.response_metadata, status: @meal_suggestion.status } }
    assert_redirected_to meal_suggestion_url(@meal_suggestion)
  end

  test "should destroy meal_suggestion" do
    assert_difference("MealSuggestion.count", -1) do
      delete meal_suggestion_url(@meal_suggestion)
    end

    assert_redirected_to meal_suggestions_url
  end
end
