import UIKit


// Class to visualize post likes and favorites icon

final class PostStatisticsView: UIView {
    
    // Updating likes number
    var numberOfLikes: Int = 0 {
        didSet {
            likesLabel.text = String(numberOfLikes)
            likesImageView.image = numberOfLikes > 0 ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        }
    }
    
    // Checking whether post is favorite by current user
    var isFavoritePost: Bool {
        didSet {
            saveFavoritesImageView.image = isFavoritePost == true ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        }
    }
    

    var onFavoritesTap: (() -> Void)?
    
    lazy var likesImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.tintColor = UIColor.monochrome
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var saveFavoritesImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.tintColor = UIColor.monochrome
        imageView.image = isFavoritePost == true ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var favoritesTapArea: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var likesLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.monochrome
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    init(frame: CGRect, isFavoritePost: Bool) {
        
        self.isFavoritePost = isFavoritePost
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
        setupFavoritesTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        addSubview(likesImageView)
        //addSubview(saveFavoritesImageView)
        addSubview(favoritesTapArea)
        favoritesTapArea.addSubview(self.saveFavoritesImageView)
        addSubview(likesLabel)
        
        NSLayoutConstraint.activate([
            likesImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            likesImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            likesImageView.widthAnchor.constraint(equalToConstant: UIConstants.likesImageSize),
            likesImageView.heightAnchor.constraint(equalToConstant: UIConstants.likesImageSize),
            
            likesLabel.leadingAnchor.constraint(equalTo: likesImageView.trailingAnchor, constant: UIConstants.likesLabelLeadingOffset),
            likesLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            likesLabel.widthAnchor.constraint(equalToConstant: UIConstants.likesLabelwidth),
            likesLabel.heightAnchor.constraint(equalToConstant: UIConstants.likesLabelHeight),
            
            favoritesTapArea.trailingAnchor.constraint(equalTo: trailingAnchor),
            favoritesTapArea.centerYAnchor.constraint(equalTo: centerYAnchor),
            favoritesTapArea.widthAnchor.constraint(equalToConstant: UIConstants.favoritesTapAreaSize),
            favoritesTapArea.heightAnchor.constraint(equalToConstant: UIConstants.favoritesTapAreaSize),
            
            saveFavoritesImageView.trailingAnchor.constraint(equalTo: favoritesTapArea.trailingAnchor, constant: UIConstants.saveFavoritesTrailingSpacing),
            saveFavoritesImageView.leadingAnchor.constraint(equalTo: favoritesTapArea.leadingAnchor, constant: UIConstants.saveFavoritesLeadingSpacing),
            saveFavoritesImageView.topAnchor.constraint(equalTo: favoritesTapArea.topAnchor, constant: UIConstants.saveFavoritesTopSpacing),
            saveFavoritesImageView.bottomAnchor.constraint(equalTo: favoritesTapArea.bottomAnchor, constant: UIConstants.saveFavoritesBottomSpacing)
        ])
        
    }
    
    // Setting up favorites area tap recognizer
    public func setupFavoritesTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(favoritesTapped))
        favoritesTapArea.isUserInteractionEnabled = true
        favoritesTapArea.addGestureRecognizer(tapGesture)
        
    }
    
    @objc public func favoritesTapped() {
        onFavoritesTap?()
    }
}
