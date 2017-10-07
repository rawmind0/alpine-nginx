#!/usr/bin/env sh

function checkError {
        if [ $1 -ne 0 ]; then
                echo "ERROR"
                exit $1
        fi
        echo "OK"
}

CURRENT_FULL=$(nginx -v 2>&1)
checkError $?

CURRENT_VERSION=$(echo ${CURRENT_FULL} | cut -d"/" -f2)

if [ "$CURRENT_VERSION" != "$SERVICE_VERSION" ]; then
        echo "ERROR got $CURRENT_VERSION expected $SERVICE_VERSION"
        exit 1
fi

echo "OK"
exit 0