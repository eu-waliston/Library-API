# frozen_string_literal: true

class ReportMailer < AplicationMailer
  def report_ready(user, filepath, report_type)
    @user = user
    @report_type = report_type

    attachments["#{report_type.downcase.gsub(' ', '_')}_#{Date.current}.pdf"] = File.read(filepath)

    mail(
      to: user.email,
      subject: "Your #{report_type} is Ready"
    )
  end
end

