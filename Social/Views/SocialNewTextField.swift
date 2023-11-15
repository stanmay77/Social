import UIKit

// Social branded textfield class

final class SocialNewTextField: UITextField {
    
    let passwordField: Bool = false
    let placeholderText: String? = nil
    let inputText: String? = nil
    let divider = Divider(frame: .zero, separatorColor: UIColor.orangeTabTint)
    
    
    init(frame: CGRect, passwordField: Bool, placeholderText: String?, inputText: String?) {
        super.init(frame: frame)
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.widthAnchor.constraint(equalTo: widthAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ]
        
        self.attributedPlaceholder = NSAttributedString(string: placeholderText ?? "", attributes: attributes)
        self.text = inputText ?? ""
        self.isSecureTextEntry = passwordField
        self.setSpacer(for: UIConstants.socialTextFieldSpacerSize)
        self.textColor = UIColor.monochrome
        self.font = UIFont.systemFont(ofSize: UIConstants.socialTextFieldFontSize)
        self.layer.cornerRadius = UIConstants.socialTextFieldCornerRadius
        self.autocapitalizationType = .none
        self.backgroundColor = .antimonochrome
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.translatesAutoresizingMaskIntoConstraints = false
    
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
