PROJECT = whospy
PROJECT_DESCRIPTION = Who Is Spy Game
PROJECT_VERSION = 0.1.0

DEPS = cowboy jsone
dep_cowboy_commit = 2.9.0
dep_jsone_commit = 1.7.0

BUILD_DEPS += relx
SHELL_OPTS = -eval 'application:ensure_all_started(whospy)'

include erlang.mk
