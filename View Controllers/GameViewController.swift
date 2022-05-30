import Firebase
import Foundation
import UIKit

class GameViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var homeLabel: UILabel!
    @IBOutlet var awayLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    
    @IBOutlet var awayGoalsTable: UITableView!
    @IBOutlet var homeGoalsTable: UITableView!
    @IBOutlet var playersTable: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        var homeGoals: [Goal] = []
        var awayGoals: [Goal] = []
        
        if game?.type == "Домашний" {
            homeGoals = (game?.ourGoals)!
            awayGoals = (game?.theirGoals)!
        }
        else {
            awayGoals = (game?.ourGoals)!
            homeGoals = (game?.theirGoals)!
        }
        
        if tableView == awayGoalsTable {
            return prepareGoalCell(ind: indexPath, table: awayGoalsTable)
        }
        
        if tableView == homeGoalsTable {
            return prepareGoalCell(ind: indexPath, table: homeGoalsTable)
        }
        
        if tableView == playersTable {
            let Pcell = tableView.dequeueReusableCell(withIdentifier: "playerPrototypeCell", for: indexPath) as! PlayerCell
            var team = game!.starting + game!.subs
            let player = team[indexPath.row]
            var info: [String: AnyObject]?
            getMatchInfo(game: game!, player: player.id) { (res: [String: AnyObject]) in
                info = res
                Pcell.gamesLabel.text = "\(info!["minutes"]!)"
            }
            let actions = getActionsInGame(game: game!, id: player.id)
            
            Pcell.goalsLabel.text = String(actions.0.count)
            Pcell.assistsLabel.text = String(actions.1.count)
            
            Pcell.nameLabel.text = String(player.name)
            Pcell.surnameLabel.text = String(player.surname)
            Pcell.numLabel.text = String(player.number)
            Pcell.id = String(player.id)
            return Pcell
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the sample data structure.
        
        var count: Int?
        var homeGoalscnt: Int
        var awayGoalscnt: Int
        
        if game?.type == "Домашний" {
            homeGoalscnt = (game?.ourGoals.count)!
            awayGoalscnt = (game?.theirGoals.count)!
        }
        else {
            awayGoalscnt = (game?.ourGoals.count)!
            homeGoalscnt = (game?.theirGoals.count)!
        }
        
        if tableView == awayGoalsTable {
            count = awayGoalscnt
        }
        
        if tableView == homeGoalsTable {
            count = homeGoalscnt
        }
        
        if tableView == playersTable {
            count = game!.starting.count + game!.subs.count
        }
        return count!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? playerProfileVewController {
            let cell = sender as! PlayerCell
            dest.id = cell.id
        }
    }
    
    func prepareGoalCell(ind: IndexPath, table: UITableView) -> GoalCell {
        var homeGoals: [Goal] = []
        var awayGoals: [Goal] = []
        
        if game?.type == "Домашний" {
            homeGoals = (game?.ourGoals)!
            awayGoals = (game?.theirGoals)!
        }
        else {
            awayGoals = (game?.ourGoals)!
            homeGoals = (game?.theirGoals)!
        }
        var Gcell = awayGoalsTable.dequeueReusableCell(withIdentifier: "GoalCellPrototype", for: ind) as! GoalCell
        let goal = table == awayGoalsTable ? awayGoals[ind.row] : homeGoals[ind.row]
        var type = ""
        
        var tableIsOurs = (game?.type == "Домашний" && table == homeGoalsTable) || (game?.type == "Выездной" && table == awayGoalsTable)
        
        if tableIsOurs {
            var scoarer: Player?
            var assistant: Player?
            
            loadPlayer(id: goal.scoarer) { (resPlayer: Player) in
                scoarer = resPlayer
                Gcell.scoarerLabel.text = scoarer!.surname + type
            }
            
            if let assistantStr = goal.assistant {
                loadPlayer(id: assistantStr) { (resPlayer: Player) in
                    assistant = resPlayer
                    Gcell.assistantLabel.text = "(" + assistant!.surname + ")"
                }
            }
        }
        Gcell.scoarerLabel.text = goal.scoarer
        var player: Player?
        
        if let assistantStr = goal.assistant {
            Gcell.assistantLabel.text = "(" + assistantStr + ")"
        }
        else {
            Gcell.assistantLabel.text = ""
        }
        Gcell.minuteLabel.text = String(goal.minute)
        
        if goal.type == "Пенальти" {
            type = " (п)"
        }
        if goal.type == "Автогол" {
            type = " (а)"
        }
        
        Gcell.scoarerLabel.text = Gcell.scoarerLabel.text! + type
        
        return Gcell
    }
    
    var game: completeGame?
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.playersTable.indexPathForSelectedRow {
            playersTable.deselectRow(at: index, animated: false)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Информация о матче"
        
        awayGoalsTable.dataSource = self
        awayGoalsTable.delegate = self
        awayGoalsTable.allowsSelection = false
        
        homeGoalsTable.dataSource = self
        homeGoalsTable.delegate = self
        homeGoalsTable.allowsSelection = false
        
        playersTable.dataSource = self
        playersTable.delegate = self
        
        dateLabel.text = getRussianDateString(date: dateFromString(dateStr: game!.date))
        
        if game?.type == "Домашний" {
            homeLabel.text = ourTeamName
            awayLabel.text = game?.rival
            
            scoreLabel.text = String(game!.ourGoals.count) + " : " + String(game!.theirGoals.count)
        }
        else {
            awayLabel.text = ourTeamName
            homeLabel.text = game?.rival
            scoreLabel.text = String(game!.theirGoals.count) + " : " + String(game!.ourGoals.count)
        }
    }
}
