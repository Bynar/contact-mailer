# Preview all emails at http://localhost:3000/rails/mailers/campaign_mailer
class CampaignMailerPreview < ActionMailer::Preview
  CampaignMailer.campaign_email(Lead.new(first_name: 'tester', email: 'test@test.com'))
end
