# Preview all emails at http://localhost:3000/rails/mailers/campaign_mailer
class CampaignMailerPreview < ActionMailer::Preview

  def campaign_email1
    @lead = Lead.new(first_name: 'tester', email: 'tester@example.com')

    CampaignMailer.campaign_email(@lead, 'template1')
  end

  def campaign_email2
    @lead = Lead.new(first_name: 'tester', email: 'tester@example.com')

    CampaignMailer.campaign_email(@lead, 'template2')
  end
end
