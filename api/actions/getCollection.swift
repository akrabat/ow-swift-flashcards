func main(args: [String:Any]) -> [String:Any] {

    let result = getJsonFrom(getSetting("couchdb_url") + "/flashcards/_design/main_design/_view/all_cards?include_docs=true")
    if result.code != 200 {
        print ("Failed to get collection of cards: code: \(result.code), result: \(result.json)")
        return jsonResponse(["error": "Failed to get cards"], code: 500)
    }

    var cards = [String: Any]()
    for item in result.json["rows"].arrayValue {
        let doc = item["doc"]

        let cardId = doc["_id"].stringValue
        let card = [
            "front": doc["front"].stringValue,
            "back": doc["back"].stringValue,
            "deck": doc["deck"].stringValue,
        ]

        cards[cardId] = card
    }
    return jsonResponse(["cards": cards])
}
