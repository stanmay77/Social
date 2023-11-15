import UIKit


// Class to show subscribed users avatars


final class FollowersView: UIView {
    
    var followedUsers: [RegisteredUser] = [] {
        didSet {
            let specialUser = followedUsers.first { $0.login == "addavatar@some.com" } // addavatar@some.com is tech user to facilitate add user avatar
            let otherUsers = followedUsers.filter { $0.login != "addavatar@some.com" }
            
            
            let sortedOtherUsers = otherUsers.sorted { $0.login < $1.login }
            
            
            followedUsers = []
            if let specialUser = specialUser {
                followedUsers.append(specialUser)
            }
            followedUsers.append(contentsOf: sortedOtherUsers)
        }
    }
    var userLogged: RegisteredUser
    
    weak var delegate: AddFollowerDelegate?
    
    lazy var followedCollection: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collectionLayout.minimumInteritemSpacing = 5
        collectionLayout.scrollDirection = .horizontal
        collection.showsHorizontalScrollIndicator = false
        collection.register(FollowerAvatarCollectionViewCell.self, forCellWithReuseIdentifier: FollowerAvatarCollectionViewCell.reuseIdentifier)
        collection.isScrollEnabled = true
        
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    init(userLogged: RegisteredUser) {
        self.userLogged = userLogged
        super.init(frame: .zero)
        loadFollowed()
        backgroundColor = .systemBackground
        followedCollection.delegate = self
        followedCollection.dataSource = self
        
        addSubview(followedCollection)
        
        
        NSLayoutConstraint.activate([
            followedCollection.topAnchor.constraint(equalTo: topAnchor),
            followedCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
            followedCollection.trailingAnchor.constraint(equalTo: trailingAnchor),
            followedCollection.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func loadFollowed() {
        
        StorageManager.shared.getFollowedUsers(for: userLogged) { [weak self] followed in
            
            guard let strongRef = self else { return }
            
            DispatchQueue.main.async {
                strongRef.followedUsers = followed
                strongRef.followedCollection.reloadData()
            }
        }
    }
    
    public func updateView() {
        followedCollection.reloadData()
        layoutIfNeeded()
    }
    
}

extension FollowersView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return followedUsers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FollowerAvatarCollectionViewCell.reuseIdentifier, for: indexPath) as? FollowerAvatarCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(for: followedUsers[indexPath.row])
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIConstants.followersCollectionViewSize, height: UIConstants.followersCollectionViewSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if followedUsers[indexPath.row].login == "addavatar@some.com" {
            delegate?.addFollowedUser()
        } else {
            delegate?.viewFollowedUser(for: followedUsers[indexPath.row])
        }
    }
    
    
}

