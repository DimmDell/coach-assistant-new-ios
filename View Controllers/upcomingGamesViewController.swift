import Foundation

import Firebase
import UIKit

class upcomingGamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    var games: [upcomingGame] = []
    
    func getGames() {
        let refGames = ref.child("events").child("upcomingGames")
        var played = false
        
        refGames.observe(.value, with: { snapshot in
            for game in snapshot.children.allObjects as! [DataSnapshot] {
                let gameObj = game.value as? [String: AnyObject]
                let arr = gameObj!["starting"] as! [[String: AnyObject]]
                let subs = gameObj!["substitutions"] as! [[String: AnyObject]]
                
                getUpcomingGamebyID(id: gameObj!["id"] as! String) { (resGame: upcomingGame) in
                    self.games.append(resGame)
                    
                    self.gamesTable.reloadData()
                }
            }
            
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcomingGamePrototypeCell", for: indexPath) as! upcomingGameTableCell
        let game = games[indexPath.row]
        cell.game = game
        
        cell.dateLabel.text = getRussianDateString(date: dateFromString(dateStr: String(game.date)))
        cell.competitionLabel.text = String(game.competition)
     
        if game.type == "Домашний" {
            cell.rivalLabel.text = ourTeamName + " – " + String(game.rival)
        }
        else {
            cell.rivalLabel.text = String(game.rival) + " – " + ourTeamName
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? upcomingGamePlayerTable {
            let cell = sender as! upcomingGameTableCell
            dest.game = cell.game
        }
    }
    
    @IBOutlet var gamesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        title = "Предстоящие матчи"
        getGames()
        
        gamesTable.reloadData()
    }
}
