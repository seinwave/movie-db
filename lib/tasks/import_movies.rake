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

MONTHS = ["JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER"]

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
}

