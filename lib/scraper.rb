require 'pry'
require 'open-uri'
require 'nokogiri'


class Scraper

  def self.scrape_index_page(index_url)
    student_hashes = []
    html = Nokogiri::HTML(open(index_url))
    html.css('div.student-card').collect do |student|
      hash = {
        name: student.css('div.card-text-container h4').text,
        location: student.css('p.student-location').text,
        profile_url: student.css('a').attribute('href').text
      }
      student_hashes << hash
    end
   student_hashes
  end

  def self.scrape_profile_page(profile_url)
    student_profile = {}
    html = Nokogiri::HTML(open(profile_url))
    html.css('.social-icon-container a').each do |student|
      if student.attribute('href').value.include?('twitter')
        student_profile[:twitter] = student.attribute('href').value
      elsif student.attribute('href').value.include?('linkedin')
        student_profile[:linkedin] = student.attribute('href').value
        elsif student.attribute('href').value.include?('github')
        student_profile[:github] = student.attribute('href').value
      else student_profile[:blog] = student.attribute('href').value
      end
    end
    student_profile[:profile_quote] = html.css('div.profile-quote').text
    student_profile[:bio] = html.css('.description-holder p').text
    # binding.pry
    student_profile
  end

end

