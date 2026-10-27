# My Kafka: a Ruby Protocol Challenge

Build a small Kafka-compatible broker in Ruby, one executable behavior at a
time. The complete 25-stage test suite is available now, but each command runs
only the prefix you select. Start red, write the smallest implementation that
passes, commit it, then choose the next stage.

The test runner is a Docker image built from the public,
MIT-licensed [CodeCrafters Kafka tester][tester] at a pinned commit. It runs
locally: no account, subscription, submission, or hosted service is involved.
Ruby is not an officially supported CodeCrafters language, but the tester only
requires an executable named `your_program.sh`, so it works with this project.

[codecrafters]: https://github.com/codecrafters-io/build-your-own-kafka
[tester]: https://github.com/codecrafters-io/kafka-tester

## Run the official tests

```sh
rake stages       # List every stage.
rake stage[vi6]   # Run only Stage 1.
rake stage[pv1]   # Run Stages 1 through 5.
rake test         # Run all 25 stages.
```

The first test command builds `my-ruby-kafka-tester:local`; later commands reuse
that image. It runs the public tester's 25 stage checks against
`your_program.sh`, which starts `bin/server` for your Ruby broker.

To build the baseline explicitly:

```sh
rake docker:build
```

## Start: Stage 1 — Bind to a port

```sh
rake stage[vi6]
```

The test currently fails because `bin/server` does not exist. Create it so it
listens on `127.0.0.1:9092`. Do not implement a response yet. Make this test
pass, commit the result, and stop there.

Do not implement a response yet. Make the listener test pass, commit the
result, and stop there.

## Rules of the challenge

1. Run the active test before reading a reference.
2. Implement the smallest behavior that passes.
3. Commit after every green stage.
4. Only then inspect the reference for that concept.
5. Write one or two notes about design differences before moving on.

## References

| Directory | Use it for |
| --- | --- |
| `../their-kafka/` | A seven-stage Java Kafka-like broker. Its Git history is the walkthrough. |
| `../their-kafka/codecrafters-definition/` | The official MIT-licensed challenge definitions and all 25 stage descriptions. |

The Java reference is useful for architecture, but it does not follow the same
stage order as this challenge. Do not copy it line-for-line.

## Roadmap

| # | Goal | Official stage file |
| ---: | --- | --- |
| 1 | Bind to port 9092 | `base-01-vi6.md` |
| 2 | Return a fixed correlation ID | `base-02-nv3.md` |
| 3 | Echo the request correlation ID | `base-03-wa6.md` |
| 4 | Reject unsupported ApiVersions | `base-04-nc5.md` |
| 5 | Return ApiVersions v4 metadata | `base-05-pv1.md` |
| 6–7 | Handle serial, then concurrent requests | `concurrent-clients-*.md` |
| 8–12 | Describe topic partitions | `listing-partitions-*.md` |
| 13–18 | Fetch records from disk | `consuming-messages-*.md` |
| 19–25 | Produce records to disk | `producing-messages-*.md` |

Read only the current stage description:

```sh
sed -n '1,220p' ../their-kafka/codecrafters-definition/stage_descriptions/base-01-vi6.md
```

## Test layout

`Dockerfile` compiles the pinned open-source tester and packages it with Ruby.
`Rakefile` selects a prefix of the 25 canonical stage checks and mounts this
repository into the image. No sibling checkout or local Go installation is
required to run tests.
