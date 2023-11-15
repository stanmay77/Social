import UIKit

// Base class for log out button for UINavigationController

final class LogOutButton: UILabel {
    
    let recognizer: UITapGestureRecognizer
    
    init(frame: CGRect, recognizer: UITapGestureRecognizer) {
        self.recognizer = recognizer
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        text = NSLocalizedString("logOutButtonTitle", comment: "")
        tintColor = .monochrome
        font = UIFont.systemFont(ofSize: 15)
        isUserInteractionEnabled = true
        addGestureRecognizer(recognizer)
    }
}
