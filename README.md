# Flashcards

Simple flashcards application deployed to OpenWhisk


## Notes:

* Site is at: http://flashcards.19ft.com (GitHub pages)
* Run side locally: 
    - `npm install -g local-web-server`
    - `cd docs`
    - `ws --spa index.html`
* Auto refresh browser on file change: `watch.rb . localhost`
* seed database:

        ./api/seed-data/seed_couchdb.sh --url https://xxx-bluemix:yyy@zzz-bluemix.cloudant.com


## Example Curl commands:

Given:

    export NAMESPACE=`wsk namespace list | tail -n1`
    export PACKAGE=flashcards

Get all cards:

    curl -ski "https://192.186.33.13/api/v1/web/$(NAMESPACE)/$(PACKAGE)/cards"

Get a card:

    curl -ski "https://192.186.33.13/api/v1/web/$(NAMESPACE)/$(PACKAGE)/cards/17d68e514e22db14b3de9148f1009dbe"

Add a card:

    curl -ski -X POST -H "Content-Type: application/json" \
    -d '{"front": "Author of Among Others", "back": "Jo Walton", "deck": "authors"}' 
    "https://192.168.33.13/api/v1/web/$(NAMESPACE)/$(PACKAGE)/cards" 


Update a card:

    curl -ski -X PUT -H "Content-Type: application/json" \
    -d '{"front": "Author of Among Others", "back": "Jo Walton", "deck": "authors"}'
    "https://192.186.33.13/api/v1/web/$(NAMESPACE)/$(PACKAGE)/cards/17d68e514e22db14b3de9148f1009dbe"

Delete a card:

    curl -ski -X DELETE "https://192.168.33.13/api/v1/web/$(NAMESPACE)/$(PACKAGE)/cards/17d68e514e22db14b3de9148f1009dbe"
