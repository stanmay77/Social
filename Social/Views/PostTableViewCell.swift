
import UIKit

// Class to format post cell in PostsVC and ProfileVC

final class PostTableViewCell: UITableViewCell {
    
    static let cellID = "postTableViewCell"
    var postImageHeightConstraint: NSLayoutConstraint?
    
    lazy var avatarView = AvatarImageView(frame: CGRect(x: 0, y: 0, width: UIConstants.postAvatarSize, height: UIConstants.postAvatarSize), bWidth: UIConstants.postAvatarBorderWidth)
    
    lazy var postTitle: UILabel = {
        let text = UILabel(frame: .zero)
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: UIConstants.postTitleFontSize, weight: .bold)
        text.textAlignment = .left
        text.textColor = UIColor.monochrome
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var postDate: UILabel = {
        let text = UILabel(frame: .zero)
        text.font = UIFont.systemFont(ofSize: UIConstants.postDateFontSize)
        text.textAlignment = .left
        text.textColor = UIColor.systemGray
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var postAuthor: UILabel = {
        let text = UILabel(frame: .zero)
        text.font = UIFont.systemFont(ofSize: UIConstants.postAuthorFontSize)
        text.textAlignment = .left
        text.textColor = UIColor.systemGray
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var postText: UILabel = {
        let text = UILabel(frame: .zero)
        text.numberOfLines = 0
        text.lineBreakMode = .byWordWrapping
        text.font = UIFont.systemFont(ofSize: UIConstants.postBodyTextFontSize)
        text.textAlignment = .left
        text.textColor = UIColor.monochrome
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    lazy var postImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
        
    }()
    
    lazy var divider = Divider(frame: .zero, separatorColor: UIColor.orangeTabTint)
    lazy var greyDivider = Divider(frame: .zero, separatorColor: UIColor.systemGray2)
    lazy var postStatView = PostStatisticsView(frame: .zero, isFavoritePost: false)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: PostTableViewCell.cellID)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Configuring post cell layout
    
    private func configureUI() {
        
        
        contentView.addSubview(postTitle)
        contentView.addSubview(postText)
        contentView.addSubview(divider)
        contentView.addSubview(postImage)
        contentView.addSubview(greyDivider)
        contentView.addSubview(postStatView)
        contentView.addSubview(postDate)
        contentView.addSubview(postAuthor)
        contentView.addSubview(avatarView)
        
        // For async image loading
        postImage.isHidden = true
        
        // Image height constaint is set dynamically, if there is an image in post
        postImageHeightConstraint = postImage.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([postImageHeightConstraint!])
        
        NSLayoutConstraint.activate([
            
            postTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.postTopAnchorSpacing),
            postTitle.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: UIConstants.postTitleAlignment),
            postTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UIConstants.postTrailingAnchorSpacing),
            
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.postTopAnchorSpacing),
            avatarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.postLeadingAnchorSpacing),
            avatarView.heightAnchor.constraint(equalToConstant: UIConstants.postAvatarSize),
            avatarView.widthAnchor.constraint(equalToConstant: UIConstants.postAvatarSize),
            
            postDate.topAnchor.constraint(equalTo: postTitle.bottomAnchor, constant: UIConstants.postDateTopSpacing),
            postDate.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: UIConstants.postTitleAlignment),
            postDate.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UIConstants.postTrailingAnchorSpacing),
            
            postAuthor.topAnchor.constraint(equalTo: postDate.bottomAnchor, constant: UIConstants.postDateTopSpacing),
            postAuthor.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: UIConstants.postTitleAlignment),
            postAuthor.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UIConstants.postTrailingAnchorSpacing),
            
            postText.topAnchor.constraint(equalTo: postAuthor.bottomAnchor, constant: UIConstants.postTextTopSpacing),
            postText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.postLeadingAnchorSpacing),
            postText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UIConstants.postTrailingAnchorSpacing),
            
            divider.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UIConstants.postTopAnchorSpacing),
            divider.bottomAnchor.constraint(equalTo: postImage.bottomAnchor),
            divider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.postDividerLeadingSpacing),
            divider.widthAnchor.constraint(equalToConstant: UIConstants.postDividerWidth),
            
            postImage.topAnchor.constraint(equalTo: postText.bottomAnchor, constant: UIConstants.postTextTopSpacing),
            postImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UIConstants.postLeadingAnchorSpacing),
            postImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UIConstants.postTrailingAnchorSpacing),
            
            greyDivider.topAnchor.constraint(equalTo: postImage.bottomAnchor, constant: UIConstants.postTextTopSpacing),
            greyDivider.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            greyDivider.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            greyDivider.heightAnchor.constraint(equalToConstant: UIConstants.postGreyDividerHeight),
            
            postStatView.topAnchor.constraint(equalTo: greyDivider.bottomAnchor, constant: UIConstants.postStatViewTopSpacing),
            postStatView.leadingAnchor.constraint(equalTo: postImage.leadingAnchor),
            postStatView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: UIConstants.postTrailingAnchorSpacing),
            postStatView.heightAnchor.constraint(equalToConstant: UIConstants.postStatViewHeight),
            postStatView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: UIConstants.postStatViewBottomSpacing)
        ])
        
        
    }
    
    // Setting post properties
    
    func configureForPost(post: Post) {
        
        postTitle.text = post.postTitle
        postText.text = post.postText
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm EEEE, dd.MM.yyyy"
        let postDateFormatted = formatter.string(from: post.postDate)
        
        postDate.text = postDateFormatted
        postAuthor.text = "Posted by: \(post.author)"
        
        self.postImage.image = nil
        
        // Checking whether there is an image in a post
        
        if post.postImage != "" {
            CloudStorageManager.shared.fetchCloudImage(for: URL(string: post.postImage)!) {  result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self.postImage.image = image
                        self.postImageHeightConstraint?.constant = UIScreen.main.bounds.width
                        self.postImageHeightConstraint?.isActive = true
                        self.postImage.isHidden = false
                        self.contentView.layoutIfNeeded()
                        
                        if let tableView = self.superview as? UITableView {
                            tableView.beginUpdates()
                            tableView.endUpdates()
                        }
                    }
                case .failure(_):
                    print("error")
                }
            }
        } else {
            DispatchQueue.main.async {
                self.postImage.image = nil
                self.postImageHeightConstraint?.constant = 0
                self.postImageHeightConstraint?.isActive = false
                self.postImage.isHidden = true
                self.layoutIfNeeded()
                if let tableView = self.superview as? UITableView {
                    tableView.beginUpdates()
                    tableView.endUpdates()
                }
            }
        }
        
        
        StorageManager.shared.getUser(by: post.author) { [weak self] user in
            CloudStorageManager.shared.fetchCloudImage(for: URL(string: user.avatarURL!)!) { result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self!.avatarView.image = image
                    }
                case .failure(_):
                    DispatchQueue.main.async {
                        self!.avatarView.image = UIImage(systemName: UIConstants.cloudUploadErrorImage)
                    }
                }
            }
        }
        
        postStatView.numberOfLikes = post.likes
        postStatView.isFavoritePost = post.isFavoritePost
        
        postStatView.onFavoritesTap = { [self] in
            
            postStatView.isFavoritePost.toggle()
            
            
            StorageManager.shared.favoritePost(docID: post.id!) { _ in }
            
            
            if postStatView.isFavoritePost {
                CoreDManager.shared.savePost(post)
                NotificationCenter.default.post(name: NSNotification.Name("postFavored"), object: nil)
            } else {
                CoreDManager.shared.deletePostContent(for: post)
                NotificationCenter.default.post(name: NSNotification.Name("postFavored"), object: nil)
            }
        }
    }
}
