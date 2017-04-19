#!/bin/bash
set -eo pipefail

declare -a jdk7_versions=(
	2.9.2
	2.9.3
	2.10.1
	2.10.2
	2.10.3
	2.10.4
	2.10.5
	2.10.6
	2.11.0
	2.11.1
	2.11.2
	2.11.4
	2.11.5
	2.11.6
	2.11.7
	2.11.8
	2.11.11
)

declare -a jdk8_versions=(
	2.12.0
	2.12.1
	2.12.2
)

function generate_dockerfile {
	local base_image="$1"
	local version="$2"
	rm -rf "$version"
	mkdir "$version"
	cat > "$version/Dockerfile" <<-EOD
		# This Dockerfile is generated by "update.sh"
		# Do not edit it locally - your changes will be lost!

		FROM $base_image

		ENV SCALA_VERSION $version
		RUN wget -q "https://www.scala-lang.org/files/archive/scala-\$SCALA_VERSION.deb" && \\
		    ( dpkg -i "scala-\$SCALA_VERSION.deb" || true ) && \\
		    apt-get update -y && apt-get install -y -f --no-install-recommends && \\
		    rm "scala-\$SCALA_VERSION.deb" && \\
		    rm -rf /var/lib/apt/lists/*
	EOD
}

for version in "${jdk7_versions[@]}"
do
	generate_dockerfile openjdk:7-jdk "$version"
done

for version in "${jdk8_versions[@]}"
do
	generate_dockerfile openjdk:8-jdk "$version"
done
