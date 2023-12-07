class PresentationsController < ApplicationController

  before_action :set_presentation, only: %i[ show edit update destroy ]

  # This will keep track of who the user is (teacher / student)
  before_action :check_user_role, only: %i[student_dashboard teacher_dashboard]

  # GET /presentations or /presentations.json
  def index
    @presentations = Presentation.all
  end

  # GET /presentations/1 or /presentations/1.json
  def show
  end

  # GET /presentations/new
  def new
    @presentation = Presentation.new
  end

  # GET /presentations/1/edit
  def edit
  end

  # POST /presentations or /presentations.json
  def create
    @presentation = current_user.presentations.new(presentation_params)

    respond_to do |format|
      if @presentation.save
        format.html { redirect_to presentation_url(@presentation), notice: "Presentation was successfully created." }
        format.json { render :show, status: :created, location: @presentation }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /presentations/1 or /presentations/1.json
  def update
    respond_to do |format|
      if @presentation.update(presentation_params)
        format.html { redirect_to presentation_url(@presentation), notice: "Presentation was successfully updated." }
        format.json { render :show, status: :ok, location: @presentation }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @presentation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /presentations/1 or /presentations/1.json
  def destroy
    @presentation.destroy

    respond_to do |format|
      format.html { redirect_to presentations_url, notice: "Presentation was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  # GET /presentations/student_dashboard
  def student_dashboard
    # Logic for student dashboard
    @presentations = current_user.presentations
  end

  # GET /presentations/teacher_dashboard
  def teacher_dashboard
    # Logic for teacher dashboard
    @presentations = current_user.presentations.includes(:evaluations)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_presentation
      @presentation = Presentation.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def presentation_params
      params.require(:presentation).permit(:title, :description, :date)
    end
  
    # Check the user's role before accessing dashboards
    def check_user_role
      redirect_to root_path unless current_user.user_type.present?
    end

end
