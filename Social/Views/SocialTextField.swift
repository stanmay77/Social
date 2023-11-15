import UIKit


class SocialTextField: UITextField {
    
    let passwordField: Bool = false
    let placeholderText: String? = nil
    let inputText: String? = nil
    
    init(frame: CGRect, passwordField: Bool, placeholderText: String?, inputText: String?) {
        super.init(frame: frame)
        
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.systemGray
        ]
        
        self.attributedPlaceholder = NSAttributedString(string: placeholderText ?? "", attributes: attributes)
        self.text = inputText ?? ""
        self.isSecureTextEntry = passwordField
        self.setSpacer(for: 10)
        self.textColor = .black
        self.font = UIFont.systemFont(ofSize: 16)
        self.layer.cornerRadius = 10
        self.autocapitalizationType = .none
        self.backgroundColor = UIColor(named: "orangeTFColor")
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
