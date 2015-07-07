class LettersController < RenalwareController

  # Cancancan authorization filter
  load_and_authorize_resource

  before_filter :load_patient, except: :author
  before_filter :load_author, only: :author

  def index
    @letters = Letter.where(patient: @patient)
  end

  def author
    @letters = Letter.where(author: @author)
  end

  def new
    @letter = Letter.new(patient: @patient)
  end

  def create
    @letter = Letter.new(letter_params)

    if LetterService.new(@letter).update!(letter_params)
      redirect_to patient_letters_path(@patient)
    else
      flash[:error] = 'Failed to save letter'
      render :new
    end
  end

  private

  def letter_params
    params.require(:letter).permit(:id, :patient_id, :author_id,
                                   :letter_type, :recipient,
                                   :other_recipient_address,
                                   :letter_description_id,
                                   :body, :signature)
  end

  def load_author
    @author = User.find(params[:author_id])
  end
end
