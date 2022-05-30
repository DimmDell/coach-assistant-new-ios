import Firebase
import Foundation
import UIKit

class trainingInfoViewController: UIViewController {
    @IBOutlet var trainingInfo: UITextView!
    var train: training?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        trainingInfo.text = train!.description
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? trainingListViewController {
            dest.players = train!.players
        }
    }
}
