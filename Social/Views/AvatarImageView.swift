import UIKit

// Base class for avatar image

final class AvatarImageView: UIImageView {
    
    var bWidth: CGFloat
    
    init(frame: CGRect, bWidth: CGFloat) {
        self.bWidth = bWidth
        super.init(frame: frame)
        self.layer.borderWidth = bWidth
        self.translatesAutoresizingMaskIntoConstraints = false
        self.clipsToBounds = true
        self.layer.borderColor = UIColor(named: "orangeUIColor")?.cgColor
        self.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
            super.layoutSubviews()
            self.layer.cornerRadius = self.frame.size.width / 2
        }
}
