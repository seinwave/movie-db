# frozen_string_literatal: true
require 'csv'
require 'net/http'
require 'json'
# open the speadsheet
# parse the year
# line by line:
# - if month, set CURRENT_MONTH
# - if movie title
#   --> get imdb_id from OMDb
#   - if has a date:
#     --> set watched_date to date
#   - if NOT has a date:
#     --> set watched_date to the 15th of CURRENT_MONTH
# --> then, save rating for relevant User
#

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
  url = URI("http://www.omdbapi.com/?t=#{URI.encode(title)}&apikey=#{omdb_key}")
  response = Net::HTTP.get(url)
  data = JSON.parse(response)
  if data['Response'] == 'True'
    data['imdb_id']
  else
    nil
  end
end

def month_to_number(month_name)
  Date::MONTHNAMES.index(month_name.capitalize)
end

def grade_to_number(grade)
  SCORES[grade]
end 

def import_data(csv_file_path)
  current_month = nil
  current_year = File.basename(csv_file_path, '.csv')

  matt = User.where(email: 'mseidholz@gmail.com')
  reba = User.where(email: 'brammershlay@gmail.com')

  CSV.foreach(file_path, headers: true) do |row|
    if MONTHS.include?(row['TITLE']) 
      current_month = row['TITLE']
      next
    end

    next if row['TITLE'].nil? || row['title'].strip.empty?

    movie_id = find_imdb_id(row['TITLE'])
    next unless movie_id

    watched_date = row['DATE']
    rebecca_score = row['REBA']
    matt_score = row['MATT']

    if watched_date.blank? && current_month && current_year
      watched_date = Date.new(current_year.to_i, month_to_number(current_month).to_i, 15)
    else 
      watched_date = Date.strptime(watched_date, '%d/%m/%y')
    end 

    if matt_score.present?
      Rating.create!(user: matt, score:   )
    end 
  end
end
