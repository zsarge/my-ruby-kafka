require "json"

STAGES = [
  ["vi6", "Bind to a port"],
  ["nv3", "Send Correlation ID"],
  ["wa6", "Parse Correlation ID"],
  ["nc5", "Parse API Version"],
  ["pv1", "Handle ApiVersions requests"],
  ["nh4", "Serial requests"],
  ["sk0", "Concurrent requests"],
  ["yk1", "Advertise DescribeTopicPartitions"],
  ["vt6", "Describe an unknown topic"],
  ["ea7", "Describe one partition"],
  ["ku4", "Describe multiple partitions"],
  ["wq2", "Describe multiple topics"],
  ["gs0", "Advertise Fetch"],
  ["dh6", "Fetch no topics"],
  ["hn6", "Fetch an unknown topic"],
  ["cm4", "Fetch an empty topic"],
  ["eg2", "Fetch one record from disk"],
  ["fd8", "Fetch multiple records from disk"],
  ["xz1", "Advertise Produce"],
  ["zf2", "Reject an invalid produce request"],
  ["gg1", "Produce to a valid topic and partition"],
  ["ls8", "Produce one record to disk"],
  ["yd8", "Produce multiple records"],
  ["ct4", "Produce to multiple partitions"],
  ["ov0", "Produce to multiple topics"]
].freeze

TEST_IMAGE = "my-ruby-kafka-tester:local"

def test_cases_through(stage_slug)
  index = STAGES.index { |slug, _| slug == stage_slug }
  abort "unknown stage #{stage_slug.inspect}; use `rake stages`" unless index

  STAGES.first(index + 1).map do |slug, title|
    { slug: slug, tester_log_prefix: slug, title: title }
  end
end

task :stages do
  STAGES.each_with_index do |(slug, title), index|
    puts format("%2d. %-3s %s", index + 1, slug, title)
  end
end

namespace :docker do
  task :build do
    sh "docker", "build", "--tag", TEST_IMAGE, __dir__
  end
end

task :ensure_test_image do
  next if system("docker", "image", "inspect", TEST_IMAGE, out: File::NULL, err: File::NULL)

  Rake::Task["docker:build"].invoke
end

task :test, [:stage] => :ensure_test_image do |_, args|
  selected_stage = args[:stage] || STAGES.last.first
  test_cases = JSON.generate(test_cases_through(selected_stage))

  sh "docker", "run", "--rm",
     "--env", "CODECRAFTERS_REPOSITORY_DIR=/workspace",
     "--env", "CODECRAFTERS_TEST_CASES_JSON=#{test_cases}",
     "--mount", "type=bind,src=#{__dir__},dst=/workspace",
     "--workdir", "/workspace",
     TEST_IMAGE
end

task :stage, [:slug] do |_, args|
  abort "use `rake stage[slug]`; use `rake stages` to list slugs" unless args[:slug]

  Rake::Task[:test].invoke(args[:slug])
end

task :complete, [:slug] do |_, args|
  abort "use `rake complete[slug]`; use `rake stages` to list slugs" unless args[:slug]

  Rake::Task[:test].invoke(args[:slug])
  Rake::Task[:test].invoke(args[:slug])

  `cd #{File.dirname File.expand_path(__FILE__)}`
  `git add -A`
  `git commit -S -m "update stage #{args[:slug]}"`
end

task default: :test
