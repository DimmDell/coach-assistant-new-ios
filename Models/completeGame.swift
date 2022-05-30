import Firebase
import Foundation

class completeGame {
    var competition, type, rival, date, id: String
    var conceded, scored: Int
    var starting: [Player] = []
    var subs: [Player] = []
    var ourGoals: [Goal] = []
    var theirGoals: [Goal] = []

    init(data: [String: Any], ourGoals: [Goal], theirGoals: [Goal], start: [Player], subs: [Player]) {
        rival = data["rival"] as! String
        competition = data["competition"] as! String
        type = data["type"] as! String
        conceded = data["conceded"] as! Int
        scored = data["scored"] as! Int
        date = data["date"] as! String
        id = data["id"] as! String

        starting = start
        self.subs = subs

        self.ourGoals = ourGoals
        self.theirGoals = theirGoals
    }
}
