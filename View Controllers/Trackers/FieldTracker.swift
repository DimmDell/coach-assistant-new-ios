import Firebase
import Foundation
import UIKit

class fieldPlayerTrackerViewController: UIViewController {
    var (hours, minutes, seconds, fractions) = (0, 0, 0, 0)
    var isTimeRunning = false
    var timer = Timer()
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var fractionsLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var position: UILabel!
    
    var player: Player? = nil
    var isStarting: Bool = false
    var game: upcomingGame? = nil
    var trackerData = FieldTrackerData()
    var dbInt: Int = 0
    
    @IBAction func addShot(_ sender: UIButton) {
        trackerData.shots += 1
        sender.setTitle("Удар (\(trackerData.shots))", for: .normal)
    }
    @IBAction func addShotOnTarget(_ sender: UIButton) {
        trackerData.shotsOnTarget += 1
        sender.setTitle("Удар в створ (\(trackerData.shotsOnTarget))", for: .normal)
    }
    @IBAction func addPass(_ sender: UIButton) {
        trackerData.succPasses += 1
        sender.setTitle("Точный пас (\(trackerData.succPasses))", for: .normal)
    }
    @IBAction func addMissedPass(_ sender: UIButton) {
        trackerData.missedPasses += 1
        sender.setTitle("Неточный пас (\(trackerData.missedPasses))", for: .normal)
    }
    
    @IBAction func addTackle(_ sender: UIButton) {
        trackerData.tackles += 1
        sender.setTitle("Отбор (\(trackerData.tackles))", for: .normal)
    }
    
    @IBAction func addRound(_ sender: UIButton) {
        trackerData.rounds += 1
        sender.setTitle("Обводка (\(trackerData.rounds))", for: .normal)
    }
    
    @IBAction func addAssist(_ sender: UIButton) {
        trackerData.assists += 1
        sender.setTitle("Ассист (\(trackerData.assists))", for: .normal)
    }
    
    @IBAction func addGoal(_ sender: UIButton) {
        trackerData.goals += 1
        sender.setTitle("Гол (\(trackerData.goals))", for: .normal)
    }
    @IBAction func setYellowCard(_ sender: UIButton) {
        trackerData.yellowCard = true
    }
    @IBAction func setRedCard(_ sender: Any) {
        trackerData.redCard = true
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(fieldPlayerTrackerViewController.keepTimer), userInfo: nil, repeats: true)
    }
    @IBAction func sendTrackedData(_ sender: UIButton) {
        let teamStr = isStarting ? "starting" : "substitutions"
        let game = ref.child("events").child("upcomingGames").child(game!.id)
        let player = game.child(teamStr).child(String(dbInt))
        
        player.updateChildValues(
          [
            "gameStats": [
              "shots": trackerData.goals,
              "shotsOnTarget": trackerData.shotsOnTarget,
              "passes": trackerData.succPasses,
              "missedPasses": trackerData.missedPasses,
              "rounds": trackerData.rounds,
              "tackles": trackerData.tackles,
              "yellowCard": trackerData.yellowCard,
              "redCard": trackerData.redCard,
              "assists": trackerData.assists,
              "goals": trackerData.goals,
              "timePlayed": [ "minutes": minutes, "seconds": seconds ]
            ]
          ]
        )

    }
    
    @IBAction func timerButtonTap(_ sender: UIButton) {
        isTimeRunning = !isTimeRunning
        
        let verb = isTimeRunning ? "Закончить" : "Начать"
        let text = verb + " отсчет времени на поле"
        
        if isTimeRunning {
            start()
        } else {
            timer.invalidate()
        }
        
        sender.setTitle(text, for: .normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = self.player?.surname
        position.text = "\(self.player!.position) \(self.player!.number) номер"
    }
     
    @objc func keepTimer() {
        fractions += 1
        
        if fractions > 99 {
            seconds += 1
            fractions = 0
        }
        
        if seconds == 60 {
            minutes += 1
            seconds = 0
        }
        
        if minutes == 60 {
            hours += 1
            minutes = 0
        }
        
        let minStr = minutes < 10 ? "0\(minutes)" : "\(minutes)"
        let secStr = seconds < 10 ? "0\(seconds)" : "\(seconds)"
        let fracStr = fractions < 10 ? "0\(fractions)" : "\(fractions)"
        
        timeLabel.text = "\(minStr) : \(secStr)"
        fractionsLabel.text = ".\(fracStr)"
    }
}

