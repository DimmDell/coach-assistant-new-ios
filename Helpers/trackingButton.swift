import UIKit

class TrackingButton: UIButton {

    var player: Player?
    var game: upcomingGame?
    var playerInd = 0

    required init(player: Player, game: upcomingGame) {
        self.player = player
        self.game = game

        super.init(frame: .zero)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.player = nil
        self.game = nil
    }

}
