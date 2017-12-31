require 'json'
require 'shellwords'

module RubocopAutomata
  # automata skill
  module Skill
    module_function

    def rubocop_autocorrect
      `rubocop --auto-correct`
      `git diff --numstat` != ''
    end

    def create_branch(repository_url, github_email, github_username, new_branch)
      `git config --local user.email "#{github_email}"`
      `git config --local user.name "#{github_username}"`
      `git checkout -b #{new_branch}`
      `git add .`
      `git commit -m ":shirt: rubocop --auto-correct"`
      `git push #{repository_url} #{new_branch}`
    end

    def create_pullrequest(repository_name, title, description, base_branch, topic_branch)
      options = <<~OPTIONS.strip
        -X POST -H "Authorization: token #{ENV['GITHUB_ACCESS_TOKEN']}" \
        --data #{Shellwords.escape({title: title, body: description, head: topic_branch, base: base_branch}.to_json)}
      OPTIONS
      `curl #{options} https://api.github.com/repos/#{repository_name}/pulls`
    end
  end
end
