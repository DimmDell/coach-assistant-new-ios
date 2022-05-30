import AwaitKit
import Firebase
import Foundation
import PromiseKit

func loadGoals(data: DataSnapshot) -> Promise<([Goal], [Goal])> {
    return Promise<([Goal], [Goal])> { seal -> () in
        var theirGoals: [Goal] = []
        var ourGoals: [Goal] = []

        let ourGoalsRef = data.childSnapshot(forPath: "ourGoals")
        let theirGoalsRef = data.childSnapshot(forPath: "theirGoals")

        for go in ourGoalsRef.children {
            let vg = initGoal(data: go as! DataSnapshot)
            ourGoals.append(vg)
        }

        for go in theirGoalsRef.children {
            let vg = initGoal(data: go as! DataSnapshot)
            theirGoals.append(vg)
        }
        seal.fulfill((ourGoals, theirGoals))
    }
}

func loadPlayer(id: String, completion: @escaping (Player) -> ()) {
    let refPlayers = ref.child("players")
    var resPlayer: Player?

    refPlayers.observe(.value, with: { snapshot in
        let data = snapshot.childSnapshot(forPath: id)
        resPlayer = initPlayer(data: data)
        if let res = resPlayer {
            completion(res)
        }
    })
}

func getPlayersArray(ids: [String], completion: @escaping ([Player]) -> ()) {
    var res: [Player] = []
    let group = DispatchGroup()

    for el in ids {
        group.enter()

        loadPlayer(id: el) {
            (resPlayer: Player) in
            res.append(resPlayer)
            group.leave()
        }
    }

    group.notify(queue: .main, execute: { completion(res) })
}

func getGamebyID(id: String, completion: @escaping (completeGame) -> ()) {
    let refGames = ref.child("events").child("completeGames")
    var resGame: completeGame?

    refGames.observe(.value, with: { snapshot in
        for game in snapshot.children.allObjects as! [DataSnapshot] {
            let data = snapshot
            let gameObj = game.value as? [String: AnyObject]

            if gameObj!["id"] as! String != id {
                continue
            }

            let goals = data.childSnapshot(forPath: id)
            let gameGoals = try! `await`(loadGoals(data: goals))

            var starting = data.childSnapshot(forPath: "starting")

            let start = gameObj!["starting"] as! [[String: AnyObject]]
            let subs = gameObj!["substitutions"] as! [[String: AnyObject]]

            var startIds = start.map { $0["id"] as! String }
            var subIds = subs.map { $0["id"] as! String }

            var startArr: [Player] = []
            var subsArr: [Player] = []
            let group = DispatchGroup()

            group.enter()
            getPlayersArray(ids: startIds) { (resTeam: [Player]) in
                startArr = resTeam
                group.leave()
            }

            group.enter()
            getPlayersArray(ids: subIds) { (resTeam: [Player]) in
                subsArr = resTeam
                group.leave()
            }
            group.notify(queue: .main, execute: { resGame = initCompleteGame(data: game, ourGoals: gameGoals.0, theirGoals: gameGoals.1, start: startArr, subs: subsArr)
                completion(resGame!)
            })
        }
    })
}

func getMatchInfo(game: completeGame, player: String, completion: @escaping ([String: AnyObject]) -> ()) {
    let refGames = ref.child("events").child("completeGames").child(game.id)
    refGames.observeSingleEvent(of: .value, with: { snapshot in
        let start = snapshot.childSnapshot(forPath: "starting").value as! [[String: AnyObject]]
        let subs = snapshot.childSnapshot(forPath: "substitutions").value as! [[String: AnyObject]]
        var team = start + subs

        var info = team.first(where: { $0["id"] as! String == player })
        completion(info!)
    })
}

func getActionsInGame(game: completeGame, id: String) -> ([Goal], [Goal]) {
    var goals: [Goal] = []
    var assists: [Goal] = []

    for el in game.ourGoals {
        if el.scoarer == id {
            goals.append(el)
        }
        if el.assistant == id {
            assists.append(el)
        }
    }
    return (goals, assists)
}

func checkPresence(arr: [[String: AnyObject]], playerID: String) -> Bool {
    var played = false
    for el in arr {
        let id = el["id"] as! String
        if id == playerID {
            played = true
        }
    }
    return played
}

func dateFromString(dateStr: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let date = dateFormatter.date(from: dateStr)
    return date!
}

func getRussianDateString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU")
    dateFormatter.dateFormat = "dd MMMM yyyy"
    let stringDate = dateFormatter.string(from: date)

    return stringDate
}

func getInjuryDateString(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU")
    dateFormatter.dateFormat = "dd.MM yyyy"
    let stringDate = dateFormatter.string(from: date)

    return stringDate
}

func getUpcomingGamebyID(id: String, completion: @escaping (upcomingGame) -> ()) {
    let refGames = ref.child("events").child("upcomingGames")
    var resGame: upcomingGame?

    refGames.observe(.value, with: { snapshot in
        for game in snapshot.children.allObjects as! [DataSnapshot] {
            let data = snapshot
            let gameObj = game.value as? [String: AnyObject]

            if gameObj!["id"] as! String != id {
                continue
            }

            var starting = data.childSnapshot(forPath: "starting")

            let start = gameObj!["starting"] as! [[String: AnyObject]]
            let subs = gameObj!["substitutions"] as! [[String: AnyObject]]

            var startIds = start.map { $0["id"] as! String }
            var subIds = subs.map { $0["id"] as! String }

            var startArr: [Player] = []
            var subsArr: [Player] = []
            let group = DispatchGroup()

            group.enter()
            getPlayersArray(ids: startIds) { (resTeam: [Player]) in
                startArr = resTeam
                group.leave()
            }

            group.enter()
            getPlayersArray(ids: subIds) { (resTeam: [Player]) in
                subsArr = resTeam
                group.leave()
            }
            group.notify(queue: .main, execute: { resGame = initUpcomingGame(data: game, start: startArr, subs: subsArr)
                completion(resGame!)
            })
        }
    })
}
