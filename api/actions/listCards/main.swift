import CouchDB
import SwiftyJSON

func main(args: [String:Any]) -> [String:Any] {

    let connectionProperties = ConnectionProperties(
        host: args["host"] as! String,
        port: Int16(args["port"] as! Int),
        secured: true,
        username: (args["username"] as! String),
        password: (args["password"] as! String)
    )
    let databaseName = "flashcards_db"
    let client = CouchDBClient(connectionProperties: connectionProperties)
    let database = client.database(databaseName)


    var cards: [String: Any]?

    database.queryByView("all_cards", ofDesign: "main_design", usingParameters: [.includeDocs(true)]) {
        (document: JSON?, error: NSError?) in
        if let document = document, error == nil {
            let list = document["rows"].arrayValue
            cards = [String: Any]()
            for item in list {
                let doc = item["doc"]

                let cardId = doc["_id"].stringValue + ":" + doc["_rev"].stringValue
                let card = [
                    "front": doc["front"].stringValue,
                    "back": doc["back"].stringValue,
                    "deck": doc["deck"].stringValue,
                ]


                cards?[cardId] = card
            }
        }
    }

    if let cards = cards {
        return [
            "cards": cards,
            "count": cards.count,
        ];
    }

    return ["error": "No data"]
}
