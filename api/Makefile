
# ------------------------------------------------------------------------------
# Variables
# NAMESPACE is your OpenWhisk namespace. Default to last item in `wsk namespace list`
# SLACK_TOKEN is the Slack API token from parameters.json
NAMESPACE = $(shell wsk namespace list | tail -n1)
PACKAGE=flashcards


# ------------------------------------------------------------------------------
# Default target: update all actions into OpenWhisk if swift file changes
.PHONY: update
update: build/listCards.zip

# ------------------------------------------------------------------------------
# Build targets

build/listCards.zip: actions/listCards/*.swift
	./compile.sh listCards
	wsk action update $(PACKAGE)/listCards build/listCards.zip --kind swift:3 \
		--annotation final true --annotation web-export true


# ------------------------------------------------------------------------------
# Run targets
.PHONY: listCards

listCards: build/listCards.zip
	curl https://openwhisk.ng.bluemix.net/api/v1/experimental/web/$(NAMESPACE)/$(PACKAGE)/listCards.json



# ------------------------------------------------------------------------------
# Misc targets
.PHONY: lastlog setup clean

lastlog:
	wsk activation list -l1 | tail -n1 | cut -d ' ' -f1 | xargs wsk activation logs

setup:
	# Create package
	wsk package update $(PACKAGE) --param-file cloudant_credentials.json

clean:
	rm -rf build/*.zip
