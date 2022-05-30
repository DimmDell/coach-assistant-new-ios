import Foundation

class Goal {
    var scoarer, type: String
    var assistant: String?
    var minute, num: Int

    init(data: [String: Any]) {
        scoarer = data["scoarer"] as! String
        if data.keys.contains("assistant") {
            assistant = data["assistant"] as? String
        }
        type = data["type"] as! String
        minute = data["minute"] as! Int
        num = data["num"] as! Int
    }
}
