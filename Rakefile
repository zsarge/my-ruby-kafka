require "rake/testtask"
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

TESTER_DIR = File.expand_path("../their-kafka/codecrafters-tester", __dir__)
TESTER = File.join(TESTER_DIR, "dist/main.out")

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

task :build_official_tester do
  sh "go", "build", "-o", TESTER, "./cmd/tester", chdir: TESTER_DIR
end

task :test, [:stage] => :build_official_tester do |_, args|
  selected_stage = args[:stage] || STAGES.last.first
  env = {
    "CODECRAFTERS_REPOSITORY_DIR" => __dir__,
    "CODECRAFTERS_TEST_CASES_JSON" => JSON.generate(test_cases_through(selected_stage))
  }

  sh env, TESTER
end

task :stage, [:slug] do |_, args|
  abort "use `rake stage[slug]`; use `rake stages` to list slugs" unless args[:slug]

  Rake::Task[:test].invoke(args[:slug])
end

Rake::TestTask.new(:smoke) do |task|
  task.libs << "lib" << "test"
  task.pattern = "test/stages/01_*_test.rb"
end

task default: :test
