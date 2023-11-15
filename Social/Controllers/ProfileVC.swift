import UIKit

// Profile and current user posts VC

class ProfileVC: UIViewController, NewPostDelegate, EditUserProtocol {

    var userLogged: RegisteredUser
    var currentUserPosts: [Post] = []
    weak var photosDelegate: UpdatePhotoGalleryDelegate?
    
    lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.cellID)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let refreshControl = UIRefreshControl()
    
    lazy var logOutButton = LogOutButton(frame: .zero, recognizer: UITapGestureRecognizer(target: self, action:  #selector(tapLogOut)))
    lazy var profileHeaderView = ProfileHeaderView(userLogged: userLogged)
    
    init(userLogged: RegisteredUser) {
        self.userLogged = userLogged
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        getUserPosts()
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = NSLocalizedString("profileVCTitle", comment: "")
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        profileHeaderView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150
        
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        let loginLabelView = UILabel(frame: .zero)
        loginLabelView.text = userLogged.login
        loginLabelView.font = UIFont.systemFont(ofSize: 15)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: logOutButton)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: loginLabelView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo:view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
        
    }
    
    @objc func tapLogOut() {
        AuthManager.shared.logOut()
        let loginVC = LoginVC(viewModel: LogViewModel())
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    
    func getUserPosts() {
        StorageManager.shared.getDocumentInfo(by: userLogged.login) { [weak self] (posts: [Post]) in
            guard let strongSelf = self else { return }
            strongSelf.currentUserPosts = posts
            strongSelf.currentUserPosts = strongSelf.currentUserPosts.sorted(by: {$1.postDate < $0.postDate})
            strongSelf.tableView.reloadData()
        }
    }
    
    
    func updateCurrentUser(using user: RegisteredUser) {
        userLogged = user
        profileHeaderView.userLogged = user
        profileHeaderView.updateView()
        getUserPosts()
    }
    
    
    @objc func refreshTableView() {
        StorageManager.shared.getUser(by: userLogged.login) { [weak self] user in
            guard let strongRef = self else { return }
            strongRef.userLogged = user
            strongRef.profileHeaderView.userLogged = user
            strongRef.profileHeaderView.updateView()
            strongRef.getUserPosts()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            self.refreshControl.endRefreshing()
        }
    }
}


extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }
        else {
            return currentUserPosts.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
           // profileHeaderView.updateView(for: userLogged)
            return profileHeaderView
        }
        else if section == 1 && currentUserPosts.count == 0 {
            return NoPostsLabelView()
        }
        else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 310
        } else if section == 1 && currentUserPosts.count == 0 {
            return 100
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && currentUserPosts.count > 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.cellID, for: indexPath) as? PostTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configureForPost(post: currentUserPosts[indexPath.row])
            return cell
        }
    else {
        return UITableViewCell()
    }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && currentUserPosts.count > 0 {
            return UITableView.automaticDimension
        }
        else
        {
            return 0
        }
    }


    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let postToDelete = currentUserPosts[indexPath.row]
            let deleteAttribute = postToDelete.id
            
            StorageManager.shared.deleteDocument(Post.self, by: deleteAttribute!) {[self] success in
                if success {
                    if postToDelete.postImage != "" {
                        CloudStorageManager.shared.deleteImageFromCloud(for: URL(string: postToDelete.postImage)!) { _ in }
                    }
                    StorageManager.shared.updateUserPostNumber(for: userLogged, number: -1)
                    userLogged.posts -= 1
                    updateCurrentUser(using: userLogged)
                    
                    userLogged.userPhotos.removeAll(where: {$0 == postToDelete.postImage})
                

              
                    StorageManager.shared.updateDocument(by: userLogged.login, fields: ["userPhotos": userLogged.userPhotos]) { (user: [RegisteredUser]) in }
                    
                    self.getUserPosts()
                } else {
                }
            }
        }
    }
}

extension ProfileVC: ProfileButtonsDelegate {
    
    func didTapNewPost(for user: RegisteredUser) {
        let vc = NewPostVC(userLogged: user)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func didTapPhotos(for user: RegisteredUser) {
        let photosVC = PhotosVC(userLogged: userLogged)
        navigationController?.pushViewController(photosVC, animated: true)
    }
    
    func didTapLocations(for user: RegisteredUser) {
        let locVC = LocationVC(userLogged: userLogged)
        navigationController?.pushViewController(locVC, animated: true)
    }
    
    func didTapEditUser(for user: RegisteredUser) {
        let editVC = EditUserVC(userToEdit: user, isEditable: true)
        editVC.delegate = self
        present(editVC, animated: true)
    }
    
}


