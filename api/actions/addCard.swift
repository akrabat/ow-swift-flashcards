func main(args: [String:Any]) -> [String:Any] {

    // ensure we have been provided the data required
    guard
        let front = args["front"] as? String,
        let back = args["back"] as? String,
        let deck = args["deck"] as? String
    else {
        return jsonResponse(["error": "Missing argument. Must have front, back & deck"], code: 400)
    }


    let card = [
        "front": front,
        "back": back,
        "deck": deck,
    ]
    var data = card
    data["type"] = "card"

    print("Adding a new card")
    let result = postJsonTo(getSetting("couchdb_url") + "/flashcards", data: data)

    if result.code != 201 {
        print("Failed to add card. Data: \(data)")
        print ("error: \(result.code): \(result.json.dictionaryObject)")
        return jsonResponse(["error": "Failed to add card"], code: 400)
    }

    let cardId = result.json["id"].stringValue
    let baseUrl = getSetting("api_base_url")
    let actionName = getFullActionName(for: "cards")
    
    // return a 201 with a Location header and the card's data
    let headers = [
        "Location": baseUrl + actionName + "/" + cardId
    ]
    return jsonResponse(card, code: 201, headers: headers)

}
