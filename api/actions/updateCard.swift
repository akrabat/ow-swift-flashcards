func main(args: [String:Any]) -> [String:Any] {
    guard let cardId = args["card_id"] as? String else {
        dump("Error: card_id missing")
        return jsonResponse(["error": "Internal Server Error"], code: 500)
    }

    // ensure we have been provided the data required
    guard
        let front = args["front"] as? String,
        let back = args["back"] as? String,
        let deck = args["deck"] as? String
    else {
        return jsonResponse(["error": "Missing argument. Must have front, back & deck"], code: 400)
    }


    print("Updating card \(cardId) in datastore")

    // 1. get card, so we can find the revision number
    var result = getJsonFrom(getSetting("couchdb_url") + "/flashcards/" + cardId)
    if result.code != 200 {
        print("Failed to find card \(cardId)")
        print ("error: \(result.code): \(result.json.dictionaryObject)")
        return jsonResponse(["error": "Card not found"], code: 404)
    }

    var doc = result.json

    let data = [
        "_rev": doc["_rev"].stringValue,
        "front": front,
        "back": back,
        "deck": deck,
        "type": "card",
    ]

    // update card with new data
    let id = doc["_id"].stringValue
    result = putJsonTo(getSetting("couchdb_url") + "/flashcards/\(id)", data: data)

    if result.code != 201 {
        print("Failed to update card. Data: \(data)")
        print ("error: \(result.code): \(result.json.dictionaryObject)")
        return jsonResponse(["error": "Failed to update card"], code: 400)
    }

    return ["statusCode": 204]
}
