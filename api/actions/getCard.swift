func main(args: [String:Any]) -> [String:Any] {

    guard let cardId = args["card_id"] as? String else {
        dump("Error: card_id missing")
        return jsonResponse(["error": "Internal Server Error"], code: 500)
    }

    print("Looking for card \(cardId) in datastore")

    // retrieve from datastore
    let result = getJsonFrom(getSetting("couchdb_url") + "/flashcards/" + cardId)
    if result.code != 200 {
        print("Failed to find card \(cardId)")
        print ("error: \(result.code): \(result.json.dictionaryObject)")
        return jsonResponse(["error": "Card not found"], code: 404)
    }

    let doc = result.json
    let card = [
        "front": doc["front"].stringValue,
        "back": doc["back"].stringValue,
        "deck": doc["deck"].stringValue,
    ]

    print("Found card \(card)")
    return jsonResponse(["card": card])
}
