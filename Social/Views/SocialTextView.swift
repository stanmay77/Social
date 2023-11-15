import UIKit

// Class for universal Social branded text view - used for post body

final class SocialTextView: UITextView {
    
    // Setting custom placeholder
    var placeholder: String = "" {
        didSet {
            placeHolderLabel.text = placeholder
        }
    }
    
    // Custom placeholder
    lazy var placeHolderLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configuring view
    private func configureUI() {
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: UITextView.textDidChangeNotification, object: nil)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(named: "orangeTFColor")
        layer.cornerRadius = UIConstants.universalCornerRadius
        font = UIFont.systemFont(ofSize: UIConstants.postTextViewFontSize)
        textColor = .black
        
        addSubview(placeHolderLabel)
        
        NSLayoutConstraint.activate([
            placeHolderLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            placeHolderLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.postTextViewPlaceholderLeadingOffset),
            placeHolderLabel.heightAnchor.constraint(equalToConstant: UIConstants.postTextViewPlaceholderHeight),
            placeHolderLabel.widthAnchor.constraint(equalToConstant: UIConstants.postTextViewPlaceholderWidth)
        ])
    }
    
    // Hiding placeholder in case user texted
    @objc private func textDidChange() {
        placeHolderLabel.isHidden = !text.isEmpty
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: nil)
    }
}
