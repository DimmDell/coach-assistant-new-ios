import UIKit

class PlayerCell: UITableViewCell {

    @IBOutlet var numLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var surnameLabel: UILabel!
    @IBOutlet var gamesLabel: UILabel!
    @IBOutlet var goalsLabel: UILabel!
    @IBOutlet var assistsLabel: UILabel!
    
    var game: upcomingGame? = nil
    
    var id: String = ""
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
