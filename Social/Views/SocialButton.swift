import UIKit

// Social branded base button class

final class SocialButton: UIButton {
    
    typealias Action = (()->Void)
    var action: Action
    
    init(frame: CGRect, buttonColor: UIColor, textColor: UIColor, buttonText: String, action: @escaping Action) {
        self.action = action
        super.init(frame: frame)
        self.setTitle(buttonText, for: .normal)
        self.backgroundColor = buttonColor
        self.setTitleColor(textColor, for: .normal)
        self.layer.cornerRadius = UIConstants.universalCornerRadius
        self.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapAction() {
        action()
    }
}
