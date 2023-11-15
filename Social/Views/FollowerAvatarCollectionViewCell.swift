import UIKit

// Class to create followers avatars

final class FollowerAvatarCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "followersAvatar"
    
    // Init of avatar view for user's avatar
    lazy var avatarView = AvatarImageView(frame: CGRect(x: 0, y: 0, width: UIConstants.followerAvatarBorderSize, height: UIConstants.followerAvatarBorderSize), bWidth: UIConstants.followerAvatarBorderWidth)
    
    // Name label
    lazy var followerNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(avatarView)
        addSubview(followerNameLabel)
        translatesAutoresizingMaskIntoConstraints = false
        
        avatarView.layer.borderColor = UIColor(named: "orangeTabTintColor")?.cgColor
        
        NSLayoutConstraint.activate([
            avatarView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            avatarView.topAnchor.constraint(equalTo: topAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: UIConstants.avatarImageSize),
            avatarView.heightAnchor.constraint(equalToConstant: UIConstants.avatarImageSize),
            
            followerNameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: UIConstants.followerAvatarTopOffset),
            followerNameLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            followerNameLabel.heightAnchor.constraint(equalToConstant: UIConstants.followerNameTopOffset),
            followerNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // Cell configuration method - fetching cloud image and setting it in avatar imageview
    public func configureCell(for user: RegisteredUser) {
        CloudStorageManager.shared.fetchCloudImage(for: URL(string: user.avatarURL!)!) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.avatarView.image = image
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.avatarView.image = UIImage(systemName: UIConstants.cloudUploadErrorImage)
                }
            }
        }
        
        // Setting follower name
        followerNameLabel.text = user.fullName
    }
}
