import Firebase
import Foundation
import UIKit

class upcomingGamePlayerTable: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int?
        if teamSwitch.selectedSegmentIndex == 0 {
            count = game!.starting.count
        }
        else if teamSwitch.selectedSegmentIndex == 1 {
            count = game!.subs.count
        }
        return count!
    }
    
    @IBOutlet var teamSwitch: UISegmentedControl!
    @IBOutlet var startTable: UITableView!
    
    @IBAction func changeTeam(_ sender: Any) {
        if teamSwitch.selectedSegmentIndex == 0 {
            players = game!.starting
            startTable.reloadData()
        }
        else if teamSwitch.selectedSegmentIndex == 1 {
            players = game!.subs
            startTable.reloadData()
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        if tableView == startTable {
            let Pcell = tableView.dequeueReusableCell(withIdentifier: "upcomingGamePlayerPrototypeCell", for: indexPath) as! UpcomingGamePlayerCell
            let player = players[indexPath.row]
            print(indexPath.row, player.id)
            
            Pcell.nameLabel.text = String(player.name)
            Pcell.surnameLabel.text = String(player.surname)
            Pcell.numLabel.text = String(player.number)
            Pcell.id = String(player.id)
            Pcell.trackingBtn.player = player
            Pcell.trackingBtn.game = game!
            Pcell.trackingBtn.playerInd = indexPath.row
            Pcell.trackingBtn.setOnClickListener {
                if player.position != "Вратарь" {
                    self.performSegue(withIdentifier: "trackerFieldSeg", sender: Pcell.trackingBtn)
                }
                else {
                    self.performSegue(withIdentifier: "trackerGoalSeg", sender: Pcell.trackingBtn)
                }
            }
            return Pcell
        }
        return cell!
    }
    
    var players: [Player] = []
    var game: upcomingGame?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? fieldPlayerTrackerViewController {
            let cell = sender as! TrackingButton
            dest.player = cell.player!
            dest.dbInt = cell.playerInd
            dest.isStarting = teamSwitch.selectedSegmentIndex == 0 ? true : false
            dest.game = cell.game!
            
        }
        else if let dest = segue.destination as? GoalKeeperTrackerViewController {
            let cell = sender as! TrackingButton
            dest.player = cell.player!
            dest.isStarting = teamSwitch.selectedSegmentIndex == 0 ? true : false
            dest.game = cell.game!
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTable.dataSource = self
        startTable.delegate = self
        
        players = game!.starting
        
        title = "Состав команды"
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
}
