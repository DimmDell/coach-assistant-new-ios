import Firebase
import Foundation
import UIKit

class trainingTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trainings.count
    }
    
    func getTrainings() {
        let refTrainings = ref.child("events").child("trainings")
        
        refTrainings.observe(.value, with: { snapshot in
            for game in snapshot.children.allObjects as! [DataSnapshot] {
                let trainObj = game.value as? [String: AnyObject]
                var playersSnap = game.childSnapshot(forPath: "players")
                
                let arr = trainObj!["players"] as! [[String: AnyObject]]
                var players: [Player] = []
                
                for player in playersSnap.children.allObjects as! [DataSnapshot] {
                    let player = initPlayer(data: player)
                    players.append(player)
                }
                var tr = initTraining(data: game, players: players)
                self.trainings.append(tr)
                self.trainingTable.reloadData()
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trainingTableCell", for: indexPath) as! trainingTableCell
        
        cell.train = trainings[indexPath.row]
        cell.countLabel.text = ""
        cell.dateLabel.text = getRussianDateString(date: dateFromString(dateStr: self.trainings[indexPath.row].date)) + " " + self.trainings[indexPath.row].time
        
        cell.nameLabel.text = String(self.trainings[indexPath.row].name)
        
        return cell
    }
    
    var trainings: [training] = []
    
    @IBOutlet var trainingTable: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? trainingInfoViewController {
            let cell = sender as! trainingTableCell
            dest.train = cell.train
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.trainingTable.dataSource = self
        self.trainingTable.delegate = self
        self.getTrainings()
        self.trainingTable.reloadData()
        self.title = "Тренировки"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
