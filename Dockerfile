# Copyright 2017 ThoughtWorks, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###############################################################################################
# This file is autogenerated by the repository at https://github.com/gocd/docker-gocd-agent.
# Please file any issues or PRs at https://github.com/gocd/docker-gocd-agent
###############################################################################################

FROM alpine:3.5
MAINTAINER GoCD <go-cd-dev@googlegroups.com>

LABEL gocd.version="17.8.0" \
  description="GoCD agent based on alpine version 3.5" \
  maintainer="GoCD <go-cd-dev@googlegroups.com>" \
  gocd.full.version="17.8.0-5277" \
  gocd.git.sha="32ff863cce99f97b76abb1b88469a793e3b1adc5"

ADD https://github.com/krallin/tini/releases/download/v0.15.0/tini-static-amd64 /usr/local/sbin/tini
ADD https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64 /usr/local/sbin/gosu

# allow mounting ssh keys, dotfiles, and the go server config and data
VOLUME /godata

# force encoding
ENV LANG=en_US.utf8

RUN \
# add mode and permissions for files we added above
  chmod 0755 /usr/local/sbin/tini && \
  chown root:root /usr/local/sbin/tini && \
  chmod 0755 /usr/local/sbin/gosu && \
  chown root:root /usr/local/sbin/gosu && \
# add our user and group first to make sure their IDs get assigned consistently,
# regardless of whatever dependencies get added
  addgroup -g 1000 go && \ 
  adduser -D -u 1000 -G go go && \
  apk --no-cache upgrade && \
  apk add --no-cache openjdk8 git mercurial subversion openssh-client bash curl && \
# download the zip file
  curl --fail --location --silent --show-error "https://download.gocd.org/binaries/17.8.0-5277/generic/go-agent-17.8.0-5277.zip" > /tmp/go-agent.zip && \
# unzip the zip file into /go-agent, after stripping the first path prefix
  unzip /tmp/go-agent.zip -d / && \
  mv go-agent-17.8.0 /go-agent && \
  rm /tmp/go-agent.zip && \
  bash -xc "export PATH=/usr/lib/jvm/default-jvm/bin:$PATH"

ADD docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]
