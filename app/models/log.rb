class Log < ApplicationRecord

  belongs_to :user
  belongs_to :story
  belongs_to :story_image
  belongs_to :pdf_image
  belongs_to :plan

  def self.create_log(log_type,id,log_action,log_detail,user)
    #log_types: Story, Story_image, Pdf_image, Plan
    #id is the object id of the applicable table
    #log_actions: Updated, Created, Approved
    
    @log = Log.new
    if log_type == "Story"
      @log.story_id = id
    end
    if log_type == "Story_image"
      @log.story_image_id = id
    end
    if log_type == "Pdf_image"
      @log.pdf_image_id = id
    end
    if log_type == "Plan"
      @log.plan_id = id
    end
    @log.log_action = log_action
    @log.log_detail = log_detail
    @log.user_id = user.id
    @log.save
  end

end
