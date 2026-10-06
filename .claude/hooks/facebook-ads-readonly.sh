#!/usr/bin/env bash
# Keep the Facebook Ads MCP read-only. Allowlist, not a denylist: any tool not
# known to only read (including tools Meta adds later) is blocked. Fails closed.
tool=$(jq -r '.tool_name // empty' 2>/dev/null) || tool=""
read_only='^mcp__facebook__(ads_get_.*|ads_insights_.*|ads_library_search|ads_account_get_activity_logs|ads_catalog_(get|list)_.*|ads_catalog_event_source_get(_.*)?|ads_experiment_(list_tests|check_eligibility|abtest_get_test|lift_get_test)|ads_pixel_(event|parameter)_read)$'
if [[ -n "$tool" && "$tool" =~ $read_only ]]; then
  exit 0
fi
jq -n --arg t "${tool:-unknown}" '{hookSpecificOutput: {hookEventName: "PreToolUse", permissionDecision: "deny", permissionDecisionReason: ("Facebook Ads MCP is read-only on this machine; " + $t + " is not an allowed read tool.")}}'
