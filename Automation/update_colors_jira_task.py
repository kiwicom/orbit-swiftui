#!/usr/bin/env python3

import os
import sys

from jira import JIRA

def create():
    # creating jira instance
    jira = JIRA(
        server="https://jira.kiwi.com", 
        basic_auth=(
            "mobilebot", 
            os.environ["mobilebotPassword"]
        )
    )

    issue_exists_and_is_unresolved = jira.search_issues(
        jql_str="summary ~ \"Update Orbit Colors\" AND type = Task AND status not in (Resolved, Done) AND Platform = iOS AND component = Core"
    )
    
    if issue_exists_and_is_unresolved:
        number_of_unresolved_issues = len(issue_exists_and_is_unresolved)

        if number_of_unresolved_issues > 1:
            # this should never happen
            issue_keys_string = ", ".join([issue.key for issue in issue_exists_and_is_unresolved])
            print(f"More than 1 issue found ({number_of_unresolved_issues}) - {issue_keys_string}")
            return 1
        
        else:
            print(f"An issue for Updating Orbit Colors already exists - {issue_exists_and_is_unresolved[0].key}")
            return 0

    else:
        # searching for a "Next App Store" version resource
        next_app_store_versions = [version for version in jira.project_versions("MOBILE") if version.name == "Next App Store"]

        if len(next_app_store_versions) > 1:
            # this should never happen
            print("More than one \"Next App Store\" version found! Use Jira search to check them.")
            return 1

        next_app_store = next_app_store_versions[0]

        # platform is stored in customfield_14207 in Jira
        platform = "customfield_14207"

        # creation of new issue
        new_issue = jira.create_issue(
            fields={
                "project":"MOBILE",
                "summary":"Update Orbit Colors",
                "components":[
                    {
                        "name":"Core"
                    }
                ],
                "issuetype":{
                    "name":"Task"
                },
                platform:{
                    "value":"iOS"
                },
                "assignee":{
                    "name":""
                },
                "fixVersions":[
                    next_app_store.raw
                ]
            }
        )

        print(f"New issue for Updating Orbit Colors was created: {new_issue.key}")
        print(f"Link: https://jira.kiwi.com/projects/MOBILE/issues/{new_issue.key}")
        return 0

if __name__ == "__main__":
    sys.exit(create())
