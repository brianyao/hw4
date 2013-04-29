# Add a declarative step here for populating the DB with movies.

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create!(movie)
  end
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  titles = page.all("table#movies tbody tr td[1]").map {|title| title.text}
  assert titles.index(e1) < titles.index(e2)
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  steps "Given I am on the RottenPotatoes home page"
  rating_list = rating_list.split(%r{,\s*})
  rating_list.each do |rating|
    if uncheck
      steps %Q{And I uncheck "ratings_#{rating}"}
    else
      steps %Q{And I check "ratings_#{rating}"}
    end
  end
end

Then /I should( not)? see movies rated: (.*)/ do |not_see, rating_list|
  steps "Given I am on the RottenPotatoes home page"
  ratings = rating_list.split(%r{,\s*})
  ratings = Movie.all_ratings - ratings if not_see
  rows = Movie.find(:all, :conditions => {:rating => ratings}).size
  page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{rows} ]")
end

Then /I should see all of the movies/ do
  rows = Movie.find(:all).size
  page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{rows} ]")
end

# Then /I should see movies sorted by (title|date)/ do |sort|
#   if sort == 'date'
#     sorted = Movie.order("release_date")
#   elsif sort == 'title'
#     sorted = Movie.order("title")
#   end
#   page.find(:xpath, "//table[@id=\"movies\"]/tbody[count(tr) = #{rows} ]")
# end

Then /the director of "(.*)" should be "(.*)"/ do |title, director|
  m = Movie.find_by_title(title)
  assert director == m.director
end