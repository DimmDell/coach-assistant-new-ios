import AwaitKit
import Firebase
import Foundation
import MessageUI

class playerProfileVewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    var player: Player?
    
    func getPlayerGames(id: String) {
        let refGames = ref.child("events").child("completeGames")
        var played = false
        
        refGames.observe(.value, with: { snapshot in
            for game in snapshot.children.allObjects as! [DataSnapshot] {
                let gameObj = game.value as? [String: AnyObject]
                let arr = gameObj!["starting"] as! [[String: AnyObject]]
                let subs = gameObj!["substitutions"] as! [[String: AnyObject]]
                
                played = arr.contains { $0["id"] as! String == id } || subs.contains { $0["id"] as! String == id }
                
                if played {
                    let info = arr.first(where: { $0["id"] as! String == id })
                    
                    getGamebyID(id: gameObj!["id"] as! String) { (resGame: completeGame) in
                        if played {
                            if let data = info {
                                self.games.append((resGame, data))
                            }
                            
                            self.gamesTable.reloadData()
                        }
                    }
                }
            }
            
        })
    }
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var positionLabel: UILabel!
    @IBOutlet var gamesLabel: UILabel!
    @IBOutlet var secondLabel: UILabel!
    @IBOutlet var thirdLabel: UILabel!
    @IBOutlet var gamesTItle: UILabel!
    @IBOutlet var secondTitle: UILabel!
    @IBOutlet var thirdTitle: UILabel!
    @IBOutlet var gamesTable: UITableView!
    @IBOutlet var injuryLabel: UILabel!
    
    var games: [(completeGame, [String: AnyObject])] = []
    
    var id: String = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = gamesTable.dequeueReusableCell(withIdentifier: "playerGamePrototypeCell", for: indexPath) as! PlayerProfileGameCell
        let game = games[indexPath.row].0
        let info = games[indexPath.row].1
        let actions = getActionsInGame(game: game, id: player!.id)
        
        cell.game = game
        cell.rival.text = game.rival
        cell.firstInfo.text = String(info["minutes"] as! Int)
        cell.score.text = game.type == "Домашний" ? String(game.scored) + " : " + String(game.conceded) : String(game.conceded) + " : " + String(game.scored)
        
        cell.secondInfo.text = String(actions.0.count)
        
        cell.thirdInfo.text = String(actions.1.count)
        
        if game.scored > game.conceded {
            cell.score.textColor = UIColor.green
        }
        else if game.scored < game.conceded {
            cell.score.textColor = UIColor.red
        }
        else {
            cell.score.textColor = UIColor.yellow
        }
        cell.competition.text = game.competition
        
        return cell
    }
    
    func fillInfo() {
        gamesTItle.text = "Игры"
        nameLabel.text = player!.name + " " + player!.surname
        positionLabel.text = player!.position
        gamesLabel.text = String(player!.games)
        if player!.injury {
            injuryLabel.text = "Травмирован до \(getInjuryDateString(date: dateFromString(dateStr: player!.recovery!)))"
        }
        if player!.position == "Вратарь" {
            secondTitle.text = "Пропущено"
            secondLabel.text = String(player!.conceded!)
            thirdTitle.text = "Сухие матчи"
            thirdLabel.text = String(player!.cleansheets!)
        }
        else {
            secondTitle.text = "Голы"
            thirdTitle.text = "Ассисты"
            
            secondLabel.text = String(player!.goals)
            thirdLabel.text = String(player!.assists)
        }
        gamesTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? GameViewController {
            let cell = sender as! PlayerProfileGameCell
            dest.game = cell.game!
        }
    }
    
    @IBAction func sendMail(_ sender: Any) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([player!.email])
            
            present(mail, animated: true)
        }
        else {
            let alert = UIAlertController(title: "Ошибка", message: "У вас не настроена электронная почта", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gamesTable.dataSource = self
        gamesTable.delegate = self
        
        loadPlayer(id: id) { (resPlayer: Player) in
            self.player = resPlayer
            
            self.fillInfo()
            self.getPlayerGames(id: self.player!.id)
        }
    }
}
