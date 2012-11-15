# coding: utf-8
namespace :candidates do  
  require 'importer'
  desc "Migración de Candidatos"
  task :import => :environment do

    # begin
      puts "Begin...."
      import = Importer.candidates
    # rescue
    #   puts "No se encontro la cuenta"
    # end
  end  
end
