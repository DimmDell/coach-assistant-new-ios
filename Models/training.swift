import Foundation

class training {
    var name, date, description, id, time: String
    var players: [Player] = []

    init(data: [String: Any], players: [Player]) {
        name = data["name"] as! String
        date = data["date"] as! String
        description = data["description"] as! String
        date = data["date"] as! String
        id = data["id"] as! String
        time = data["time"] as! String

        self.players = players
    }
}
