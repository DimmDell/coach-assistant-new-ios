import Foundation

class Player {
    var name, surname, position, id, email: String
    var number, goals, assists, games, weight, height: Int
    var cleansheets, conceded: Int?
    var recovery: String?
    var injury: Bool
    // recovery as YYYY-MM-DD

    init(data: [String: Any]) {
        self.injury = data["injury"] as! Bool
        self.name = data["name"] as! String
        self.surname = data["surname"] as! String
        self.number = data["number"] as! Int
        self.goals = data["goals"] as! Int
        self.assists = data["assists"] as! Int
        self.games = data["games"] as! Int
        self.position = data["position"] as! String
        self.cleansheets = data["cleansheets"] as? Int ?? nil
        self.recovery = data["recovery"] as? String ?? "nah"
        self.weight = data["weight"] as! Int
        self.height = data["height"] as! Int
        self.conceded = data["conceded"] as? Int ?? nil
        self.id = data["id"] as! String
        self.email = data["email"] as! String
    }
}
