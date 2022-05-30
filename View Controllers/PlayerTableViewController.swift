import Firebase
import UIKit

class PlayerTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.players.count
    }
    
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
    
    var players: [Player] = []
    
    @IBOutlet var playerTable: UITableView!
    
    func loadPlayers() {
        let refPlayers = ref.child("players")
        
        refPlayers.observe(DataEventType.value, with: { snapshot in
            if snapshot.childrenCount > 0 {
                for player in snapshot.children.allObjects as! [DataSnapshot] {
                    let player = initPlayer(data: player)
                    self.players.append(player)
                    
                    self.playerTable.reloadData()
                }
            }
            self.playerTable.reloadData()
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? playerProfileVewController {
            let cell = sender as! PlayerCell
            dest.id = cell.id
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Состав команды"
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        self.loadPlayers()
        self.playerTable.reloadData()
    }
}
