import UIKit

class upcomingGameTableCell: UITableViewCell {

    
    @IBOutlet var rivalLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var competitionLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
    var game : upcomingGame? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
