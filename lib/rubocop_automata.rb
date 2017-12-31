require 'rubocop_automata/version'
require 'rubocop_automata/skill'

require 'rubocop_automata/ci/local'
require 'rubocop_automata/ci/circleci'

# Create GitHub PullRequest of rubocop --auto-correct in CI Service
module RubocopAutomata
  module_function

  @@backend_ci = RubocopAutomata::CI::CircleCI

  def boot(github_email:, github_username:)
    if ENV['GITHUB_ACCESS_TOKEN'].nil?
      raise 'Please input ENV of GITHUB_ACCESS_TOKEN'
    end

    if RubocopAutomata::Skill.rubocop_autocorrect
      RubocopAutomata::Skill.create_branch(
        @@backend_ci.repository_url,
        github_email,
        github_username,
        @@backend_ci.topic_branch
      )
      RubocopAutomata::Skill.create_pullrequest(
        @@backend_ci.repository_name,
        @@backend_ci.pullrequest_title,
        @@backend_ci.pullrequest_description,
        @@backend_ci.base_branch,
        @@backend_ci.topic_branch
      )
    end

    true
  end

  def backend_ci=(ci)
    @@backend_ci = ci
  end
end
