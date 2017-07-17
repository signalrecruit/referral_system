class BuildApplicantScoreService
  def initialize(params)
  	@applicant = params[:applicant]
  	@jd = params[:jd]
  	@count = params[:count]
  end

  def build_score 
  	build_applicant_score
  end


  private 

  def build_applicant_score
  	@jd.requirements.count.times { @applicant.requirement_scores.build }  
    @applicant.requirement_scores.each do |score|
      score.requirement_content = @jd.requirements[@count].content
      score.requirement_id = @jd.requirements[@count].id
      score.job_description_id = @jd.id
      @count += 1
    end 
  end
end