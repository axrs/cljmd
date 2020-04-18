#!/usr/bin/env bats
load util

@test "can run scripts that include dependencies" {
	run example-scripts/echo.clj first-arg second-arg "third arg is a string"
	[[ "$status" -eq 0 ]]

	array_contains 'Hello! from the other side' "${lines[@]}"
	array_contains 'Script: example-scripts/echo.clj' "${lines[@]}"
	array_contains "Script dir: $(pwd)/example-scripts" "${lines[@]}"
	array_contains "Current working dir: $(pwd)" "${lines[@]}"
	array_contains 'cljog version: 0.4.1' "${lines[@]}"
	array_contains 'Clojure version: {:major 1,' "${lines[@]}"
	array_contains 'Command line args: [first-arg second-arg third arg is a string]' "${lines[@]}"
	array_contains 'Random string:' "${lines[@]}"
}

@test "scripts that throw uncaught exceptions have a non-zero exit code" {
	run example-scripts/exception.clj
	[[ "$status" -eq 1 ]]
}

@test "scripts with --deps load an additional `deps.edn` file from the script directory" {
	run example-scripts/deps.clj "Extra Arg"
	[[ "$status" -eq 0 ]]

	array_contains 'This script was run with additional deps provided by deps.edn' "${lines[@]}"
}

@test "scripts with --deps=deps_file.edn load then additional `deps_file.edn` file from the script directory" {
	run example-scripts/deps_file.clj "Extra Arg"
	[[ "$status" -eq 0 ]]

	array_contains 'This script was run with additional deps provided by deps_file.edn' "${lines[@]}"
}
