namespace :reporting do
  desc "Send a daily system report email to configured recpients"
  task send_daily_summary_email: :environment do
    recipents = Array(ENV.fetch("DAILY_REPORT_EMAIL_RECIPIENTS", "dev@airslie.com").split(","))
    Renalware::Reporting::ReportMailer.daily_summary(to: recipents).deliver_later
  end
end
