#!/bin/bash
set -ex

# Validate Parameters
if [ -z "${plist_path}" ] ; then
    echo " [!] Missing required input: plist_path"
    exit 1
fi
if [ ! -f "${plist_path}" ] ; then
    echo " [!] Plist file doesn't exist at specified Info.plist path: ${plist_path}"
    exit 2
fi
if [ -z "${build_version}" ] ; then
    echo " [!] No build_version specified!"
    exit 3
fi

$RELEASE_NAME = ${APP_NAME}-${APP_VERSION}

node node_modules/react-native/local-cli/cli.js bundle \
    --platform ios \
    --entry-file index.js \
    --dev false \
    --bundle-output "${TMP_DIR}/main.jsbundle" \
    --sourcemap-output "${TMP_DIR}/main.jsbundle.map"

node_modules/@sentry/cli/bin/sentry-cli releases files $RELEASE_NAME upload-sourcemaps \
    --dist $BITRISE_BUILD_NUMBER \
    --rewrite "${TMP_DIR}/main.jsbundle.map" "${TMP_DIR}/main.jsbundle"


#
# --- Exit codes:
# The exit code of your Step is very important. If you return
#  with a 0 exit code `bitrise` will register your Step as "successful".
# Any non zero exit code will be registered as "failed" by `bitrise`.
