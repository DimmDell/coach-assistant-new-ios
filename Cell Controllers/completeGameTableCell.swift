import UIKit

class completeGameTableCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBOutlet var rivalLabel: UILabel!
    @IBOutlet var competitionLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
    var game: completeGame? = nil
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
