
# ENV2PROPS

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/c811f6b557ee4e44ad373084015ba0b3)](https://www.codacy.com/app/Codacy/env2props?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=codacy/env2props&amp;utm_campaign=Badge_Grade)
[![CircleCI](https://circleci.com/gh/codacy/env2props.svg?style=svg)](https://circleci.com/gh/codacy/env2props)
[![](https://img.shields.io/github/release/codacy/env2props.svg)](https://github.com/codacy/env2props/releases)



This is a tool to transform your environment variables into the java Properties format intended to be passed from the command line.

e.g.:

```
$ env
LC_PAPER=en_US.UTF-8
LC_MONETARY=en_US.UTF-8
LANG=en_US.UTF-8

$ env2props
-DLC.PAPER="en_US.UTF-8" -DLC.MONETARY="en_US.UTF-8" -DLANG="en_US.UTF-8"
```

Under the option `-p` or `--prefix` you can pass a matching prefix for the environment variables.

e.g.:

```
$ env
LC_PAPER=en_US.UTF-8
LC_MONETARY=en_US.UTF-8
LANG=en_US.UTF-8

$ env2props -p LC_
-DPAPER="en_US.UTF-8" -DMONETARY="en_US.UTF-8"
```

The output is provided on standard output and without any additional new-line, as it is intended to be used in-line within java command execution.

## Conventions

Each environment variable is transformed as follows:

 - remove the trailing prefix (if specified)
 - trasform all the `_` characters into `.`

## Usage

After making the binary executable and available on the `PATH`(should work out-of-the-box on any linux machine).
You can use this tool in-line while launching java applications e.g.:

```
sh -c "java $(env2props) -jar <application>.jar"
```

## Rationale

According to the [Twelve-factor App](https://12factor.net/config) the configuration should be passed to the applications via environment variables.

The "de-facto" standard for configuration in Scala application is [Typesafe Config](https://github.com/lightbend/config) and env variables are a [supported fallback](https://github.com/lightbend/config#optional-system-or-env-variable-overrides); still it is not possible to override *virtually* any configuration of our application if not properly encoded the binding accordingly.

Although [Typesafe Config](https://github.com/lightbend/config#overview) offers a first class integration with Java system properties:

> users can override the config with Java system properties

This makes it easy to bridge the gap and by having a standard way to convert environment variables into Java system properties make it possible to fully comply with [Twelve-factor App](https://12factor.net/config).

## Compile

You need to have the crystal compiler available in your classpath to succesfully build this utility, otherwise you can compile it statically using a docker image using `make buildStatic`.

## What is Codacy

[Codacy](https://www.codacy.com/) is an Automated Code Review Tool that monitors your technical debt, helps you improve your code quality, teaches best practices to your developers, and helps you save time in Code Reviews.

### Among Codacy’s features

- Identify new Static Analysis issues
- Commit and Pull Request Analysis with GitHub, BitBucket/Stash, GitLab (and also direct git repositories)
- Auto-comments on Commits and Pull Requests
- Integrations with Slack, HipChat, Jira, YouTrack
- Track issues in Code Style, Security, Error Proneness, Performance, Unused Code and other categories

Codacy also helps keep track of Code Coverage, Code Duplication, and Code Complexity.

Codacy supports PHP, Python, Ruby, Java, JavaScript, and Scala, among others.

## Free for Open Source

Codacy is free for Open Source projects.

## License

git-version is available under the Apache 2 license. See the LICENSE file for more info.
