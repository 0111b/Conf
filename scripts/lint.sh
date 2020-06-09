#!/bin/sh

swiftlint lint --path Sources --config ../.swiftlint.yml --strict
swiftlint lint --path Tests --config ../.swiftlint.yml --strict