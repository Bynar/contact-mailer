# Preview all emails at http://localhost:3000/rails/mailers/campaign_mailer
class CampaignMailerPreview < ActionMailer::Preview
  CampaignMailer.campaign_email(Lead.where('first_name is not null').last)
end
