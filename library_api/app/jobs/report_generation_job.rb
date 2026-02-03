# app/jobs/report_generation_job.rb
class ReportGenerationJob < ApplicationJob
  queue_as :reports

  def perform(user_id, report_type, start_date, end_date)
    user = User.find(user_id)

    case report_type
    when 'loans'
      generate_loans_report(user, start_date, end_date)
    when 'fines'
      generate_fines_report(user, start_date, end_date)
    when 'inventory'
      generate_inventory_report(start_date, end_date)
    end
  end

  private

  def generate_loans_report(user, start_date, end_date)
    loans = user.loans
                .where(borrowed_at: start_date..end_date)
                .includes(:book, :book_copy)

    # Cria PDF com os dados
    pdf = LoansReportPdf.new(loans, start_date, end_date)

    # Salva no storage
    filename = "loans_report_#{user.id}_#{Time.current.to_i}.pdf"
    filepath = Rails.root.join('tmp', 'reports', filename)

    pdf.render_file(filepath)

    # Envia por email
    ReportMailer.report_ready(user, filepath, 'Loans Report').deliver_now
  end

  # ... outros métodos de relatório
end