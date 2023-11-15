import UIKit

// Base class for separator

final class Separator: UIView {
    
    var separatorColor: UIColor
    
    init(frame: CGRect, separatorColor: UIColor) {
        self.separatorColor = separatorColor
        super.init(frame: frame)
        self.layer.borderColor = separatorColor.cgColor
        self.layer.borderWidth = 1
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
