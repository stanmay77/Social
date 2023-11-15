import UIKit

// Base class to visualize vertical labels for subscriptions, posts and followers in ProfileHeaderView

final class VerticalImageLabelView: UIView {
    
    typealias Action = (()->Void)
    
    var image: UIImage
    var text: String
    var recognizer: UITapGestureRecognizer? = nil
    var action: Action
    
    lazy var imageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = self.image
        image.contentMode = .scaleAspectFit
        image.tintColor = .monochrome
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        return image
    }()
    
    lazy var textLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = self.text
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .monochrome
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        return label
    }()
    
    init(frame: CGRect, image: UIImage, text: String, action: @escaping Action) {
        self.image = image
        self.text = text
        self.action = action
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(imageView)
        addSubview(textLabel)
        
        NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: topAnchor),
                    imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                    imageView.widthAnchor.constraint(equalToConstant: UIConstants.verticalViewImageViewWidth),
                    imageView.heightAnchor.constraint(equalToConstant: UIConstants.verticalViewImageViewHeight),
                    
                    textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: UIConstants.verticalViewTextLabelTopSpacing),
                    textLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                    textLabel.heightAnchor.constraint(equalToConstant: UIConstants.verticalViewTextLabelHeight),
                    textLabel.widthAnchor.constraint(equalToConstant: UIConstants.verticalViewTextLabelWidth),
        ])
    }
    
    @objc func tapAction() {
        action()
    }
}
