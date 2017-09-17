
# ------------------------------------------------------------------------------
# Variables
# NAMESPACE is your OpenWhisk namespace. Default to last item in `wsk namespace list`
# SLACK_TOKEN is the Slack API token from parameters.json
NAMESPACE = $(shell wsk namespace list | tail -n1)
PACKAGE=flashcards

# list of actions to build
ACTIONS = cards getCollection getCard addCard updateCard deleteCard

ZIPS=$(ACTIONS:%=build/%.zip)



# ------------------------------------------------------------------------------
.PHONY: all upload
all: $(ZIPS)

# force an upload to OpenWhisk
upload: $(ZIPS)
	./updateAction.sh $(PACKAGE) $?


# build an action's zip file from it's action directory
build/%.zip: actions/%.swift actions/common/*
	@cat actions/common/*.swift actions/$(@F:.zip=).swift > build/$(@F:.zip=).swift
	./compile.sh $(@F:.zip=)
	./updateAction.sh $(PACKAGE) $@


# ------------------------------------------------------------------------------
# Misc targets
.PHONY: lastlog setup clean distclean

lastlog:
	wsk activation list -l1 | tail -n1 | cut -d ' ' -f1 | xargs wsk activation logs

setup:
	# Create package
	wsk package update $(PACKAGE) --param-file parameters.json

clean:
	rm -rf build/*.swift
	rm -rf build/*.zip

distclean: clean
	./deleteActions.sh $(PACKAGE) $(ACTIONS)
	wsk package delete $(PACKAGE)
