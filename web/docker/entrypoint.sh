#!/bin/bash



# if you are using windows, you may need to convert the file to unix format
# you can use the Ubuntu terminal to convert this file to unix format
# otherwise, you may get the error after running the docker container

# sudo apt-get install dos2unix
# dos2unix entrypoint.sh


set -e

resolve_first_nonempty() {
  for var_name in "$@"; do
    value="${!var_name:-}"
    if [ -n "$value" ]; then
      printf '%s' "$value"
      return
    fi
  done
}

resolve_legacy_url() {
  primary_name="$1"
  legacy_name="$2"
  suffix="$3"

  primary_value="${!primary_name:-}"
  if [ -n "$primary_value" ]; then
    printf '%s' "$primary_value"
    return
  fi

  legacy_value="${!legacy_name:-}"
  if [ -n "$legacy_value" ]; then
    printf '%s%s' "$legacy_value" "$suffix"
  fi
}

export NEXT_PUBLIC_DEPLOY_ENV="$(resolve_first_nonempty NEXT_PUBLIC_DEPLOY_ENV DEPLOY_ENV)"
export NEXT_PUBLIC_EDITION="$(resolve_first_nonempty NEXT_PUBLIC_EDITION EDITION)"
export NEXT_PUBLIC_API_PREFIX="$(resolve_legacy_url NEXT_PUBLIC_API_PREFIX CONSOLE_API_URL /console/api)"
export NEXT_PUBLIC_PUBLIC_API_PREFIX="$(resolve_legacy_url NEXT_PUBLIC_PUBLIC_API_PREFIX APP_API_URL /api)"
export NEXT_PUBLIC_MARKETPLACE_API_PREFIX="$(resolve_legacy_url NEXT_PUBLIC_MARKETPLACE_API_PREFIX MARKETPLACE_API_URL /api/v1)"
export NEXT_PUBLIC_MARKETPLACE_URL_PREFIX="$(resolve_first_nonempty NEXT_PUBLIC_MARKETPLACE_URL_PREFIX MARKETPLACE_URL)"
export NEXT_PUBLIC_SENTRY_DSN="$(resolve_first_nonempty NEXT_PUBLIC_SENTRY_DSN SENTRY_DSN WEB_SENTRY_DSN)"
export NEXT_PUBLIC_SITE_ABOUT="$(resolve_first_nonempty NEXT_PUBLIC_SITE_ABOUT SITE_ABOUT)"
export NEXT_PUBLIC_AMPLITUDE_API_KEY="$(resolve_first_nonempty NEXT_PUBLIC_AMPLITUDE_API_KEY AMPLITUDE_API_KEY)"
export NEXT_PUBLIC_TEXT_GENERATION_TIMEOUT_MS="$(resolve_first_nonempty NEXT_PUBLIC_TEXT_GENERATION_TIMEOUT_MS TEXT_GENERATION_TIMEOUT_MS)"
export NEXT_PUBLIC_CSP_WHITELIST="$(resolve_first_nonempty NEXT_PUBLIC_CSP_WHITELIST CSP_WHITELIST)"
export NEXT_PUBLIC_ALLOW_EMBED="$(resolve_first_nonempty NEXT_PUBLIC_ALLOW_EMBED ALLOW_EMBED)"
export NEXT_PUBLIC_ALLOW_INLINE_STYLES="$(resolve_first_nonempty NEXT_PUBLIC_ALLOW_INLINE_STYLES ALLOW_INLINE_STYLES)"
export NEXT_PUBLIC_ALLOW_UNSAFE_DATA_SCHEME="$(resolve_first_nonempty NEXT_PUBLIC_ALLOW_UNSAFE_DATA_SCHEME ALLOW_UNSAFE_DATA_SCHEME)"
export NEXT_PUBLIC_TOP_K_MAX_VALUE="$(resolve_first_nonempty NEXT_PUBLIC_TOP_K_MAX_VALUE TOP_K_MAX_VALUE)"
export NEXT_PUBLIC_INDEXING_MAX_SEGMENTATION_TOKENS_LENGTH="$(resolve_first_nonempty NEXT_PUBLIC_INDEXING_MAX_SEGMENTATION_TOKENS_LENGTH INDEXING_MAX_SEGMENTATION_TOKENS_LENGTH)"
export NEXT_PUBLIC_MAX_TOOLS_NUM="$(resolve_first_nonempty NEXT_PUBLIC_MAX_TOOLS_NUM MAX_TOOLS_NUM)"
export NEXT_PUBLIC_ENABLE_WEBSITE_JINAREADER="$(resolve_first_nonempty NEXT_PUBLIC_ENABLE_WEBSITE_JINAREADER ENABLE_WEBSITE_JINAREADER)"
export NEXT_PUBLIC_ENABLE_WEBSITE_FIRECRAWL="$(resolve_first_nonempty NEXT_PUBLIC_ENABLE_WEBSITE_FIRECRAWL ENABLE_WEBSITE_FIRECRAWL)"
export NEXT_PUBLIC_ENABLE_WEBSITE_WATERCRAWL="$(resolve_first_nonempty NEXT_PUBLIC_ENABLE_WEBSITE_WATERCRAWL ENABLE_WEBSITE_WATERCRAWL)"
export NEXT_PUBLIC_LOOP_NODE_MAX_COUNT="$(resolve_first_nonempty NEXT_PUBLIC_LOOP_NODE_MAX_COUNT LOOP_NODE_MAX_COUNT)"
export NEXT_PUBLIC_MAX_PARALLEL_LIMIT="$(resolve_first_nonempty NEXT_PUBLIC_MAX_PARALLEL_LIMIT MAX_PARALLEL_LIMIT)"
export NEXT_PUBLIC_MAX_ITERATIONS_NUM="$(resolve_first_nonempty NEXT_PUBLIC_MAX_ITERATIONS_NUM MAX_ITERATIONS_NUM)"
export NEXT_PUBLIC_MAX_TREE_DEPTH="$(resolve_first_nonempty NEXT_PUBLIC_MAX_TREE_DEPTH MAX_TREE_DEPTH)"

if [ "${EXPERIMENTAL_ENABLE_VINEXT:-}" = "true" ]; then
  exec node /app/targets/vinext/server.js
fi

exec node /app/targets/next/web/server.js
