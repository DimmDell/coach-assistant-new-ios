import Firebase
import Foundation

class upcomingGame {
    var competition, type, rival, date, id: String
    var starting: [Player] = []
    var subs: [Player] = []

    init(data: [String: Any], start: [Player], subs: [Player]) {
        rival = data["rival"] as! String
        competition = data["competition"] as! String
        type = data["type"] as! String
        date = data["date"] as! String
        id = data["id"] as! String

        starting = start
        self.subs = subs
    }
}
