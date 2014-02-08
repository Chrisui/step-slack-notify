
if [ ! -n "$WERCKER_SLACK_WEBHOOK_URL" ]; then
	error 'Please specify the Slack team webhook url and activate the integration on your Slack settings'
	exit 1
fi

if [ ! -n "$WERCKER_SLACK_NOTIFY_PASSED_MESSAGE" ]; then
	if [ ! -n "$DEPLOY"]; then
		export WERCKER_SLACK_NOTIFY_PASSED_MESSAGE="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME: build of $WERCKER_GIT_BRANCH by $WERCKER_STARTED_BY passed."
	else
		export WERCKER_SLACK_NOTIFY_PASSED_MESSAGE="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME: deploy to $WERCKER_DEPLOYTARGET_NAME by $WERCKER_STARTED_BY passed."
	fi
fi

if [ ! -n "$WERCKER_SLACK_NOTIFY_FAILED_MESSAGE" ]; then
	if [ ! -n "$DEPLOY"]; then
		export WERCKER_SLACK_NOTIFY_FAILED_MESSAGE="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME: build of $WERCKER_GIT_BRANCH by $WERCKER_STARTED_BY failed."
	else
		export WERCKER_SLACK_NOTIFY_FAILED_MESSAGE="$WERCKER_APPLICATION_OWNER_NAME/$WERCKER_APPLICATION_NAME: deploy to $WERCKER_DEPLOYTARGET_NAME by $WERCKER_STARTED_BY failed."
	fi
fi

if [ ! -n "$WERCKER_RESULT" = "passed" ]; then
	export WERCKER_SLACK_NOTIFY_MESSAGE="$WERCKER_SLACK_NOTIFY_PASSED_MESSAGE"
	export ICON_EMOJI=":white_check_mark:"
else
	export WERCKER_SLACK_NOTIFY_MESSAGE="$WERCKER_SLACK_NOTIFY_FAILED_MESSAGE"
	export ICON_EMOJI=":x:"
fi

curl -X POST -H "Content-Type: application/json" -d "payload={ \"channel\": \"#equalizze-api\", \"username\": \"wercker\", \"text\": \"$WERCKER_SLACK_NOTIFY_MESSAGE\", \"icon_emoji\": \"$ICON_EMOJI\" }" $WERCKER_SLACK_WEBHOOK_URL
