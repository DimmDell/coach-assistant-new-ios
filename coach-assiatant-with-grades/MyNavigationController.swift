import ENSwiftSideMenu
import UIKit


class MyNavigationController: ENSideMenuNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a table view controller
        let tableViewController = sideMenuTableController()
        
        // Create side menu
        sideMenu = ENSideMenu(sourceView: view, menuViewController: tableViewController, menuPosition: .left)
        
        // Set a delegate
        sideMenu?.delegate = self
        
        // Configure side menu
        sideMenu?.menuWidth = 180.0
        
        // Show navigation bar above side menu
        view.bringSubviewToFront(navigationBar)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MyNavigationController: ENSideMenuDelegate {
    func sideMenuWillOpen() {}
    
    func sideMenuWillClose() {}
    
    func sideMenuDidClose() {}
    
    func sideMenuDidOpen() {}
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        return true
    }
}
