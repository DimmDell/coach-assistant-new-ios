import Firebase
import Foundation
import UIKit

class trainingListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count
    }
    
    var players: [Player] = []
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerPrototypeCell", for: indexPath) as! PlayerCell
        let player = players[indexPath.row]
        cell.assistsLabel.text = String(player.assists)
        cell.gamesLabel.text = String(player.games)
        cell.goalsLabel.text = String(player.goals)
        cell.nameLabel.text = String(player.name)
        cell.surnameLabel.text = String(player.surname)
        cell.numLabel.text = String(player.number)
        cell.id = String(player.id)
        
        return cell
    }
    
    @IBOutlet var playerTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Состав тренирующихся"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.playerTable.reloadData()
    }
}
