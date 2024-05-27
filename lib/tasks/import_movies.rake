# frozen_string_literal: true
require 'csv'
require 'net/http'
require 'json'

SCORES = {
  "Fart Minus" => -1000,
  "F"  => 0,
  "D-" => 1,
  "D"  => 2,
  "D+" => 3,
  "C-" => 4,
  "C"  => 5,
  "C+" => 6,
  "B-" => 7,
  "B"  => 8,
  "B+" => 9,
  "A-" => 10,
  "A"  => 11,
  "A+" => 12
}.freeze

def find_imdb_id(title)
  omdb_key = Rails.application.credentials.dig(:omdb)
  url = URI("http://www.omdbapi.com/?t=#{CGI.escape(title)}&apikey=#{omdb_key}")
  response = Net::HTTP.get(url)
  data = JSON.parse(response)
  data['Response'] == 'True' ? data['imdbID'] : nil
end

def month_to_number(month_name)
  Date::MONTHNAMES.index(month_name.capitalize)
end

def grade_to_number(grade)
  SCORES[grade]
end

def import_data(csv_file_path)
  puts 'FOUND CSV!'
  current_month = nil
  current_year = File.basename(csv_file_path, '.csv').to_i

  matt = User.find_by(email: 'mseidholz@gmail.com')
  reba = User.find_by(email: 'brammershlay@gmail.com')

  months = Date::MONTHNAMES.compact

  CSV.foreach(csv_file_path, headers: true) do |row|
    puts 'ROW!!'
    next if row['TITLE'].nil? || row['TITLE'].strip.empty?
    if months.include?(row['TITLE'].capitalize)
      current_month = row['TITLE']
      next
    end


    movie_id = find_imdb_id(row['TITLE'])
    next unless movie_id

    watched_date = row['DATE']
    rebecca_grade = row['REBA']
    matt_grade = row['MATT']

    if watched_date.blank? && current_month && current_year
      watched_date = Date.new(current_year, month_to_number(current_month), 15)
    else
      watched_date = Date.strptime(watched_date, '%m/%d/%y') rescue nil
    end

    if matt_grade.present?
      Rating.create!(user_id: matt.id, score: grade_to_number(matt_grade), watched_date:, imdb_id: movie_id)
    end

    if rebecca_grade.present?
      Rating.create!(user_id: reba.id, score: grade_to_number(rebecca_grade), watched_date:, imdb_id: movie_id)
    end
  end
end

namespace :movies do
  desc "Import movie ratings from CSV files"
  task import: :environment do
    puts 'TASK INITIATED!'
    Dir.glob('movie-csvs/*.csv') do |csv_file_path|
      puts 'DOING THE TASK!'
      import_data(csv_file_path)
    end
  end
end
