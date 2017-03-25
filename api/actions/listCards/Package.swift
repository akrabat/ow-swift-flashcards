import PackageDescription

let package = Package(
    name: "Action",
    dependencies: [
        .Package(url: "https://github.com/IBM-Swift/Kitura-net.git", "1.0.1"),
        .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", "14.2.0"),
        .Package(url: "https://github.com/IBM-Swift/Kitura-CouchDB.git", majorVersion: 1, minor: 0),
        // // .Package(url: "https://github.com/IBM-Swift/swift-watson-sdk.git", "0.4.1")

        // .Package(url: "https://github.com/IBM-Swift/Kitura-net.git", majorVersion: 1),
        // .Package(url: "https://github.com/IBM-Swift/SwiftyJSON.git", majorVersion: 15),
        // .Package(url: "https://github.com/IBM-Swift/Kitura-CouchDB.git", majorVersion: 1),
        // .Package(url: "https://github.com/IBM-Swift/swift-watson-sdk.git", "0.4.1"),
    ]
)
