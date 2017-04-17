
# ------------------------------------------------------------------------------
# Variables
# NAMESPACE is your OpenWhisk namespace. Default to last item in `wsk namespace list`
# SLACK_TOKEN is the Slack API token from parameters.json
NAMESPACE = $(shell wsk namespace list | tail -n1)
PACKAGE=flashcards


# ------------------------------------------------------------------------------
# Default target: update all actions into OpenWhisk if swift file changes
.PHONY: update
update: cards getCollection getCard addCard updateCard deleteCard


# ------------------------------------------------------------------------------
# Build targets
cards: build/cards.zip
	wsk action update $(PACKAGE)/cards build/cards.zip --kind swift:3 --web true

build/cards.zip: actions/cards.swift actions/common/*.swift
	./compile.sh cards

getCollection: build/getCollection.zip
	wsk action update $(PACKAGE)/getCollection build/getCollection.zip --kind swift:3

build/getCollection.zip: actions/getCollection.swift actions/common/*.swift
	./compile.sh getCollection

getCard: build/getCard.zip
	wsk action update $(PACKAGE)/getCard build/getCard.zip --kind swift:3

build/getCard.zip: actions/getCard.swift actions/common/*.swift
	./compile.sh getCard

addCard: build/addCard.zip
	wsk action update $(PACKAGE)/addCard build/addCard.zip --kind swift:3

build/addCard.zip: actions/addCard.swift actions/common/*.swift
	./compile.sh addCard

updateCard: build/updateCard.zip
	wsk action update $(PACKAGE)/updateCard build/updateCard.zip --kind swift:3

build/updateCard.zip: actions/updateCard.swift actions/common/*.swift
	./compile.sh updateCard

deleteCard: build/deleteCard.zip
	wsk action update $(PACKAGE)/deleteCard build/deleteCard.zip --kind swift:3

build/deleteCard.zip: actions/deleteCard.swift actions/common/*.swift
	./compile.sh deleteCard






# listCards: build/listCards.zip
# 	wsk action update $(PACKAGE)/listCards build/listCards.zip --kind swift:3 --web true

# build/listCards.zip: actions/listCards/*.swift
# 	./compile.sh listCards



# ------------------------------------------------------------------------------
# Run targets
.PHONY: curlListCards

curlCollection:
	curl -k https://192.186.33.13/api/v1/web/$(NAMESPACE)/$(PACKAGE)/cards

curlGet:
	curl -k https://192.186.33.13/api/v1/web/$(NAMESPACE)/$(PACKAGE)/cards/17d68e514e22db14b3de9148f1009dbe




# ------------------------------------------------------------------------------
# Misc targets
.PHONY: lastlog setup clean

lastlog:
	wsk activation list -l1 | tail -n1 | cut -d ' ' -f1 | xargs wsk activation logs

setup:
	# Create package
	wsk package update $(PACKAGE) --param-file settings.json

clean:
	rm -rf build/*.zip
