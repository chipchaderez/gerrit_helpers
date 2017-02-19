#! /bin/bash

GERRIT_URL=https://gerrit.ovirt.org

function get_change_id() {
  git show  --shortstat  | grep Change-Id | gawk '{print $2}'
}

#
# return: the commit hash of the parent of this Change-Id
#
function get_commit_of_parent() {
  local change_id=$(get_change_id)
    curl -s ${GERRIT_URL}/changes/$change_id/revisions/current/related | sed '1d' | jq '.[][0] | .commit.commit' | tr -d '"'
}

#
# return the parent refs/changes/NNN of the current Change-Id
#
function get_parent_ref() {
  git ls-remote -q | grep $(get_commit_of_parent) | gawk '{print $2}'
}
