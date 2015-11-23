# Preview all emails at http://localhost:3000/rails/mailers/campaign_mailer
class CampaignMailerPreview < ActionMailer::Preview

  def template1
    @lead = Lead.new(first_name: 'tester', email: 'tester@example.com')

    CampaignMailer.campaign_email(@lead, 'template1')
  end

  def template2
    @lead = Lead.new(first_name: 'tester', email: 'tester@example.com')

    CampaignMailer.campaign_email(@lead, 'template2')
  end

  def template3
    @lead = Lead.new(first_name: 'tester', email: 'tester@example.com')

    CampaignMailer.campaign_email(@lead, 'template3')
  end

  def template4
    @lead = Lead.new(first_name: 'tester', email: 'tester@example.com')

    CampaignMailer.campaign_email(@lead, 'template4')
  end

  def template5
    @lead = Lead.new(first_name: 'tester', email: 'tester@example.com')

    CampaignMailer.campaign_email(@lead, 'template5')
  end

  def template6
    @lead = Lead.new(first_name: 'tester', email: 'tester@example.com')

    CampaignMailer.campaign_email(@lead, 'template6')
  end

  def template7
    @lead = Lead.new(first_name: 'tester', email: 'tester@example.com')

    CampaignMailer.campaign_email(@lead, 'template7')
  end

  def template7L
    @lead = Lead.new(first_name: 'tester', email: 'tester@example.com')

    CampaignMailer.campaign_email(@lead, 'template7L')
  end

  def template8
    @lead = Lead.new(first_name: 'tester', email: 'tester@example.com')

    CampaignMailer.campaign_email(@lead, 'template8')
  end

  def template10
    @lead = Lead.new(first_name: 'tester', email: 'tester@example.com')

    CampaignMailer.campaign_email(@lead, 'template10')
  end

  def template11
    @lead = Lead.new(first_name: 'tester', email: 'tester@example.com')

    CampaignMailer.campaign_email(@lead, 'template11')
  end
end
