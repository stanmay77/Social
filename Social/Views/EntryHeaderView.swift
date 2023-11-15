import UIKit

// Class to facilitate header in login screen with app logo

final class EntryHeaderView: UIView {
    
    lazy var logoImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = UIImage(named: "logo.png")
        image.layer.shadowColor = UIColor(named: "orangeUIShadowColor")?.cgColor
        image.layer.shadowRadius = UIConstants.logoImageShadowRadius
        image.layer.shadowOpacity = Float(UIConstants.logoImageShadowOpacity)
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        self.addSubview(logoImage)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        logoImage.topAnchor.constraint(equalTo: self.topAnchor),
        logoImage.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        logoImage.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        logoImage.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        logoImage.widthAnchor.constraint(equalToConstant: UIConstants.logoImageWidth),
        logoImage.heightAnchor.constraint(equalToConstant: UIConstants.logoImageHeight)
        ])
    }
    
    
    
    
}
