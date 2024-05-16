class MealSuggestionsController < ApplicationController
  before_action :set_meal_suggestion, only: %i[ show edit update destroy ]

  # GET /meal_suggestions or /meal_suggestions.json
  def index
    @meal_suggestions = MealSuggestion.all
  end

  # GET /meal_suggestions/1 or /meal_suggestions/1.json
  def show
    @similar_meal_suggestions = @meal_suggestion.get_similar_meal_suggestions[:results]
  end

  # GET /meal_suggestions/new
  def new
    @meal_suggestion = MealSuggestion.new
  end

  # GET /meal_suggestions/1/edit
  def edit
  end

  # POST /meal_suggestions or /meal_suggestions.json
  def create
    @meal_suggestion = MealSuggestion.new(meal_suggestion_params)

    respond_to do |format|
      if @meal_suggestion.save
        format.html { redirect_to meal_suggestion_url(@meal_suggestion), notice: "Meal suggestion was successfully created." }
        format.json { render :show, status: :created, location: @meal_suggestion }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @meal_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meal_suggestions/1 or /meal_suggestions/1.json
  def update
    respond_to do |format|
      if @meal_suggestion.update(meal_suggestion_params)
        format.html { redirect_to meal_suggestion_url(@meal_suggestion), notice: "Meal suggestion was successfully updated." }
        format.json { render :show, status: :ok, location: @meal_suggestion }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @meal_suggestion.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meal_suggestions/1 or /meal_suggestions/1.json
  def destroy
    @meal_suggestion.destroy!

    respond_to do |format|
      format.html { redirect_to meal_suggestions_url, notice: "Meal suggestion was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meal_suggestion
      @meal_suggestion = MealSuggestion.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def meal_suggestion_params
      params.require(:meal_suggestion).permit(:status, :request_metadata, :response_metadata, :request_body, :response_body)
    end
end
