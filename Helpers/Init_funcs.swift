import Firebase
import Foundation

func initPlayer(data: DataSnapshot) -> Player {
    var player: Player

    let playerObj = data.value as? [String: AnyObject]

    player = Player(data: playerObj!)

    return player
}

func initGoal(data: DataSnapshot) -> Goal {
    var goal: Goal

    let goalObj = data.value as? [String: AnyObject]

    goal = Goal(data: goalObj!)

    return goal
}

func initCompleteGame(data: DataSnapshot, ourGoals: [Goal], theirGoals: [Goal], start: [Player], subs: [Player]) -> completeGame {
    var game: completeGame

    let gameObj = data.value as? [String: AnyObject]

    game = completeGame(data: gameObj!, ourGoals: ourGoals, theirGoals: theirGoals, start: start, subs: subs)

    return game
}

func initUpcomingGame(data: DataSnapshot, start: [Player], subs: [Player]) -> upcomingGame {
    var game: upcomingGame

    let gameObj = data.value as? [String: AnyObject]

    game = upcomingGame(data: gameObj!, start: start, subs: subs)

    return game
}

func initTraining(data: DataSnapshot, players: [Player]) -> training {
    var train: training

    let gameObj = data.value as? [String: AnyObject]

    train = training(data: gameObj!, players: players)

    return train
}
