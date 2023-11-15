import UIKit

// Base class for divider

class Divider: UIView {
    
    var separatorColor: UIColor
    
    init(frame: CGRect, separatorColor: UIColor) {
        self.separatorColor = separatorColor
        super.init(frame: frame)
        self.backgroundColor = separatorColor
        self.layer.borderColor = separatorColor.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
