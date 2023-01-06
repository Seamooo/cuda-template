PROJECT_NAME = hello

.PHONY: run
run:
	bazel run //$(PROJECT_NAME):main

.PHONY: build
build:
	bazel build //$(PROJECT_NAME):main


.PHONY: env_setup
env_setup:
	bazel run @hedron_compile_commands//:refresh_all

# TODO integrate below with bazel
.PHONY: fmt
fmt:
	@SOURCE_FILES=$$(find $(PROJECT_NAME) | grep -Ee "\.([chi](pp|xx)|(cc|hh|ii)|[CHI]|cu(\.cc)?)$$"); \
	[ -z "$$SOURCE_FILES" ] || clang-format -i -style=file $$SOURCE_FILES

.PHONY: lint
lint:
	bazel build //$(PROJECT_NAME):main \
  --aspects @bazel_clang_tidy//clang_tidy:clang_tidy.bzl%clang_tidy_aspect \
  --output_groups=report \
  --@bazel_clang_tidy//:clang_tidy_config=//:clang_tidy_config

.PHONY: test
test:
	bazel test test:*

.PHONY: clean
clean:
	rm bazel-*
	rm external

