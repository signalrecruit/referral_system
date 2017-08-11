module Admin::ApplicantsHelper
  def any_changes_to_score? applicant_copy, applicant
    @score = 0.0
    @number_of_requirements = 0
    if any_changes_to_req_scores applicant_copy, applicant
      applicant_copy.requirement_scores.where(copy: true, job_description_id: applicant_copy.job_description_id).each do |req_score|
        @score += req_score.score
        @number_of_requirements += 1
      end 	
    end 
    @score = (@score/@number_of_requirements) * 100
     yield @score
  end	

  def any_changes_to_req_scores applicant, applicant_copy 
  	applicant.requirement_scores.zip(applicant_copy.requirement_scores).any? { |original_req_score, copy_req_score| original_req_score.score != copy_req_score.score }
  end
end
