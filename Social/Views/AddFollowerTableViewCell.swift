import UIKit

// Cell for add followers view

final class AddFollowerTableViewCell: UITableViewCell {
    
    static let cellID = "AddFollowerCell"
    
    lazy var avatarView = AvatarImageView(frame: CGRect(x: 0, y: 0, width: UIConstants.addFollowerCellAvatarSize, height: UIConstants.addFollowerCellAvatarSize), bWidth: UIConstants.addFollowerCellAvatarBorderWidth)
    
    lazy var followerNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .monochrome
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(avatarView)
        addSubview(followerNameLabel)
        
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: topAnchor, constant: UIConstants.addFollowerCellTopSpacing),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.addFollowerCellLeadingSpacing),
            avatarView.widthAnchor.constraint(equalToConstant: UIConstants.addFollowerCellAvatarWidth),
            avatarView.heightAnchor.constraint(equalToConstant: UIConstants.addFollowerCellAvatarHeight),
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            followerNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            followerNameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: UIConstants.addFollowerCellNameLabelLeadingSpacing)
        ])
    }
    
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
        
        followerNameLabel.text = user.fullName
        
    }
    
    
}
