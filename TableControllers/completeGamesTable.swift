import Firebase
import Foundation
import UIKit

class completeGamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    var games: [completeGame] = []
    
    func getCompleteGames() {
        let refGames = ref.child("events").child("completeGames")
        
        refGames.observe(.value, with: { snapshot in
            for game in snapshot.children.allObjects as! [DataSnapshot] {
                let gameObj = game.value as? [String: AnyObject]
                let arr = gameObj!["starting"] as! [[String: AnyObject]]
                let subs = gameObj!["substitutions"] as! [[String: AnyObject]]
                
                getGamebyID(id: gameObj!["id"] as! String) { (resGame: completeGame) in
                    self.games.append(resGame)
                    
                    self.gamesTable.reloadData()
                }
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingGamePrototypeCell", for: indexPath) as! completeGameTableCell
        let game = games[indexPath.row]
        
        cell.game = game
        cell.competitionLabel.text = String(game.competition)
        cell.typeLabel.text = String(game.type)
        cell.rivalLabel.text = String(game.rival)
        
        cell.scoreLabel.text = game.type == "Домашний" ? String(game.scored) + " : " + String(game.conceded) : String(game.conceded) + " : " + String(game.scored)
        if game.scored > game.conceded {
            cell.scoreLabel.textColor = UIColor.green
        }
        else if game.scored < game.conceded {
            cell.scoreLabel.textColor = UIColor.red
        }
        else {
            cell.scoreLabel.textColor = UIColor.yellow
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? GameViewController {
            let cell = sender as! completeGameTableCell
            dest.game = cell.game!
        }
    }
    
    @IBOutlet var gamesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCompleteGames()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        title = "Прошедшие матчи"
        
        gamesTable.reloadData()
    }
}
