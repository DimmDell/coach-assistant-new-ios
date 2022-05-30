import UIKit

class PlayerProfileGameCell: UITableViewCell {
    @IBOutlet var rival: UILabel!
    @IBOutlet var score: UILabel!
    @IBOutlet var competition: UILabel!
    @IBOutlet var firstInfo: UILabel!
    @IBOutlet var secondInfo: UILabel!
    @IBOutlet var thirdInfo: UILabel!
    
    var game : completeGame? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
