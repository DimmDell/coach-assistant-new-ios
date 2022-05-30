import Foundation
import UIKit

class sideMenuTableController: UITableViewController {
    private let menuOptionCellId = "Cell"
    var selectedMenuItem: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Customize apperance of table view
        tableView.contentInset = UIEdgeInsets(top: 64.0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor.systemBackground
        tableView.scrollsToTop = false
        
        // Preserve selection between presentations
        clearsSelectionOnViewWillAppear = false
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    var views = ["Состав", "Предстоящие игры", "Прошедшие игры", "Тренировки"]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return views.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: menuOptionCellId)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: menuOptionCellId)
            cell!.backgroundColor = .systemBackground
            cell!.textLabel?.textColor = .label
            cell?.textLabel?.adjustsFontSizeToFitWidth = true
            let selectedBackgroundView = UIView(frame: CGRect(x: 0, y: 0, width: cell!.frame.size.width, height: cell!.frame.size.height))
            selectedBackgroundView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            cell!.selectedBackgroundView = selectedBackgroundView
        }
        
        if views[indexPath.row] == "Состав" {
            cell!.textLabel?.text = "Состав"
        }
        else if views[indexPath.row] == "Предстоящие игры" {
            cell!.textLabel?.text = "Предстоящие игры"
        }
        else if views[indexPath.row] == "Прошедшие игры" {
            cell!.textLabel?.text = "Прошедшие игры"
        }
        else if views[indexPath.row] == "Тренировки" {
            cell!.textLabel?.text = "Тренировки"
        }
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMenuItem = indexPath.row
        
        // Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        var destViewController: UIViewController
        switch indexPath.row {
        case 0:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "playersTable")
        case 1:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "upcomingGamesViewController")
        case 2:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "completeGamesViewController")
        case 3:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "trainingsViewController")
        default:
            destViewController = mainStoryboard.instantiateViewController(withIdentifier: "playersTable")
        }
        sideMenuController()?.setContentViewController(destViewController)
    }
}
