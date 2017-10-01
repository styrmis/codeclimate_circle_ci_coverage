require 'open-uri'
require 'json'

class CircleCi2
  ARTIFACT_PREFIX = "coverage"

  def download_files
    if ENV["CIRCLE_TOKEN"].nil?
      puts "You must create a Circle CI API token to use this on Circle CI 2.0"
      puts "Please create that, and store the key as CIRCLE_TOKEN"
      return []
    end

    api_url = "https://circleci.com/api/v1.1/project/github/#{ENV['CIRCLE_PROJECT_USERNAME']}/#{ENV['CIRCLE_PROJECT_REPONAME']}/#{ENV['CIRCLE_BUILD_NUM']}/artifacts?circle-token=#{ENV['CIRCLE_TOKEN']}"
    artifacts = open(api_url)

    JSON.load(artifacts).select do |artifact|
      artifact['path'] == "home/circleci/project/#{ARTIFACT_PREFIX}/.resultset.json"
    end.map do |artifact|
      JSON.load(open("#{artifact['url']}?circle-token=#{ENV['CIRCLE_TOKEN']}"))
    end
  end
end
