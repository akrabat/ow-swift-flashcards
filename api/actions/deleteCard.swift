func main(args: [String:Any]) -> [String:Any] {
    guard let cardId = args["card_id"] as? String else {
        dump("Error: card_id missing")
        return jsonResponse(["error": "Internal Server Error"], code: 500)
    }

    print("Deleting card \(cardId) in datastore")

    // 1. get card, so we can find the revision number
    var result = getJsonFrom(getSetting("couchdb_url") + "/flashcards/" + cardId)
    if result.code != 200 {
        print("Failed to find card \(cardId)")
        print ("error: \(result.code): \(result.json.dictionaryObject)")
        return jsonResponse(["error": "Card not found"], code: 404)
    }
    var doc = result.json
    let rev = doc["_rev"].stringValue

    // delete card
    let url = getSetting("couchdb_url") + "/flashcards/\(cardId)?rev=\(rev)"
    result = sendDelete(url)

    if result.code != 200 {
        print("Failed to delete card")
        print ("error: \(result.code): \(result.json.dictionaryObject)")
        return jsonResponse(["error": "Failed to delete card"], code: 400)
    }

    return ["statusCode": 204]
}
