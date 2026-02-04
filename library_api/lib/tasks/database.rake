namespace :db do
  desc 'Reset database and seed with sample data'
  task reset_and_seed: :environment do
    if Rails.env.development?
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      Rake::Task['db:migrate'].invoke
      Rake::Task['db:seed'].invoke
      puts 'Database reset and seeded successfully!'
    else
      puts 'This task can only be run in development environment!'
    end
  end

  desc 'Generate sample data'
  task sample_data: :environment do
    require 'faker'

    puts 'Generating sample data...'
    # Adicione lógica para gerar dados de teste adicionais
  end
end