#!/bin/bash
set -eo pipefail

declare -a versions=(
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

for version in "${versions[@]}"
do
	rm -rf "$version"
	mkdir "$version"
	cat > "$version/Dockerfile" <<-EOD
		# This Dockerfile is generated by "update.sh"
		# Do not edit it locally - your changes will be lost!

		FROM java:7-jdk
		MAINTAINER Abigail <AbigailBuccaneer@users.noreply.github.com>

		ENV SCALA_VERSION $version
		RUN wget -q "http://www.scala-lang.org/files/archive/scala-\$SCALA_VERSION.deb" && \\
		    ( dpkg -i "scala-\$SCALA_VERSION.deb" || true ) && \\
		    apt-get update -y && apt-get install -y -f --no-install-recommends && \\
		    rm "scala-\$SCALA_VERSION.deb" && \\
		    rm -rf /var/lib/apt/lists/*
	EOD
done
