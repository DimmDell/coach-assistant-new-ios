import UIKit

class GoalCell: UITableViewCell {
    @IBOutlet var scoarerLabel: UILabel!
    @IBOutlet var assistantLabel: UILabel!
    @IBOutlet var minuteLabel: UILabel!
    
    var id: String? = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
