import UIKit


// Followed users posts VC

class PostsVC: UIViewController, AddFollowerDelegate, NewFollowedDelegate {

    var userLogged: RegisteredUser
    var followedPosts: [Post] = []
    
    
    private let refreshControl = UIRefreshControl()
    
    lazy var logOutButton = LogOutButton(frame: .zero, recognizer: UITapGestureRecognizer(target: self, action:  #selector(tapLogOut)))

    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.cellID)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    lazy var followersView = FollowersView(userLogged: userLogged)
    
    init(userLogged: RegisteredUser) {
        self.userLogged = userLogged
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFollowersPosts()
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = NSLocalizedString("postsVCTitle", comment: "")
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        followersView.delegate = self
        
        
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        let barAvatarView = AvatarImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40), bWidth: 0.5)
        barAvatarView.translatesAutoresizingMaskIntoConstraints = true

        
        CloudStorageManager.shared.fetchCloudImage(for: URL(string: self.userLogged.avatarURL!)!) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    barAvatarView.image = image
                }
            case .failure(_):
                DispatchQueue.main.async {
                    barAvatarView.image = UIImage(systemName: UIConstants.cloudUploadErrorImage)
                }
            }
        }
        
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: barAvatarView)]
        barAvatarView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        barAvatarView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logOutButton)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(postLikeTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        tableView.addGestureRecognizer(doubleTapRecognizer)
       
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc func tapLogOut() {
        AuthManager.shared.logOut()
        let loginVC = LoginVC(viewModel: LogViewModel())
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }

    func getFollowersPosts() {
        var loadedPosts: [Post] = []
        let dispatchGroup = DispatchGroup()

        for followedUser in userLogged.meFollowing {
            dispatchGroup.enter()
            StorageManager.shared.getUser(by: followedUser) { user in
                StorageManager.shared.getDocumentInfo(by: user.login) { (posts: [Post]) in
                    loadedPosts.append(contentsOf: posts)
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.followedPosts = loadedPosts.sorted(by: {$0.postDate > $1.postDate})
            self.tableView.reloadData()
        }
    }
    
    func addFollowedUser() {
        let vc = AddFollowedVC(userLogged: userLogged)
        vc.modalPresentationStyle = .formSheet
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func viewFollowedUser(for follower: RegisteredUser) {
        let vc = EditUserVC(userToEdit: follower, isEditable: false)
        vc.modalPresentationStyle = .formSheet
        present(vc, animated: true)
    }
    
    @objc func refreshTableView() {
        getFollowersPosts()
        followersView.loadFollowed()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.refreshControl.endRefreshing()
        }
    }
 
    func changeFollowedUsers(for user: RegisteredUser, remove: Bool, with followed: RegisteredUser) {
        userLogged = user
        followersView.userLogged = user
        if remove {
            followersView.followedUsers.removeAll(where: {$0.login==followed.login})
        } else {
            followersView.followedUsers.append(followed)
        }
        followersView.updateView()
        getFollowersPosts()
    }
    
    
    
    @objc func postLikeTap(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: tableView)
        if let tappedIndexPath = tableView.indexPathForRow(at: tapLocation) {
            StorageManager.shared.likePost(docID: followedPosts[tappedIndexPath.row].id!, by: userLogged) {[weak self] post in
                guard let strongRef = self else { return }
                strongRef.followedPosts[tappedIndexPath.row] = post
                strongRef.tableView.reloadData()
            }
        }
    }
}

extension PostsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return followedPosts.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if followedPosts.count > 0 {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return followersView
        } else if section == 1 && followedPosts.count == 0 {
            return NoPostsLabelView()
        }
        else {
            return UIView()
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 && followedPosts.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.cellID, for: indexPath) as? PostTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configureForPost(post: followedPosts[indexPath.row])
            cell.selectionStyle = .none
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 100
        } else if section == 1 && followedPosts.count == 0 {
            return 100
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && followedPosts.count > 0 {
            return UITableView.automaticDimension
        }
        else
        {
            return 0
        }
    }
}
