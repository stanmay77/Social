import UIKit

// VC to add followers

class AddFollowedVC: UIViewController {
    
    var usersToFollow: [RegisteredUser] = []
    var alreadyFollowedUsers: [RegisteredUser] = []
    var userLogged: RegisteredUser
    weak var delegate: NewFollowedDelegate?
    var addFollowersTableViewHeightConstraint: NSLayoutConstraint?
    var alreadyFollowedTableViewHeightConstraint: NSLayoutConstraint?
    
    
    lazy var addFollowersTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textColor = .monochrome
        label.text = NSLocalizedString("addFollowersVCTitle", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var alreadyFollowedLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("alreadyFollowedLabel", comment: "")
        label.textColor = .monochrome
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var addFollowerGreetingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("addFollowerGreetingLabel", comment: "")
        label.textColor = .monochrome
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let alreadyFollowedTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(AddFollowerTableViewCell.self, forCellReuseIdentifier: AddFollowerTableViewCell.cellID)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemBackground
        return table
    }()
    

    let addFollowersTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(AddFollowerTableViewCell.self, forCellReuseIdentifier: AddFollowerTableViewCell.cellID)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .systemBackground
        return table
    }()
    
    lazy var divider = Divider(frame: .zero, separatorColor: UIColor.orangeTabTint)
    
    init(userLogged: RegisteredUser) {
        self.userLogged = userLogged
        super.init(nibName: nil, bundle: nil)
        print("Init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getUsersToFollow()
        getAlreadyFollowedUsers()
    }
    
    

    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(addFollowersTitle)
        view.addSubview(divider)
        view.addSubview(addFollowerGreetingLabel)
        view.addSubview(alreadyFollowedLabel)
        view.addSubview(alreadyFollowedTableView)
        view.addSubview(addFollowersTableView)
        
        addFollowerGreetingLabel.isHidden = true
        alreadyFollowedLabel.isHidden = true
        
        addFollowersTableViewHeightConstraint = addFollowersTableView.heightAnchor.constraint(equalToConstant: 0) // Initial height
        alreadyFollowedTableViewHeightConstraint = alreadyFollowedTableView.heightAnchor.constraint(equalToConstant: 0) // Initial height

        // Activate constraints
        addFollowersTableViewHeightConstraint?.isActive = true
        alreadyFollowedTableViewHeightConstraint?.isActive = true
    
        addFollowersTableView.delegate = self
        addFollowersTableView.dataSource = self
        
        alreadyFollowedTableView.delegate = self
        alreadyFollowedTableView.dataSource = self
        alreadyFollowedTableView.allowsSelection = false
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(addFollowedUser(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        addFollowersTableView.addGestureRecognizer(doubleTapRecognizer)

        
        NSLayoutConstraint.activate([
            addFollowersTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.addFollowedTitleTopAnchor),
            addFollowersTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.addFollowedTitleLeadingAnchor),
            addFollowersTitle.widthAnchor.constraint(equalToConstant: UIConstants.addFollowedTitleWidth),
            addFollowersTitle.heightAnchor.constraint(equalToConstant: UIConstants.addFollowedTitleHeight),

            divider.topAnchor.constraint(equalTo: addFollowersTitle.bottomAnchor, constant: UIConstants.addFollowedDividerTopSpacing),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.addFollowedDividerLeadingTrailingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.addFollowedDividerLeadingTrailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: UIConstants.addFollowedDividerHeight),

            alreadyFollowedLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: UIConstants.addFollowedAlreadyFollowedLabelTopSpacing),
            alreadyFollowedLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.addFollowedLabelLeadingTrailingAnchor),
            alreadyFollowedLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.addFollowedLabelLeadingTrailingAnchor),
            alreadyFollowedLabel.heightAnchor.constraint(equalToConstant: UIConstants.addFollowedAlreadyFollowedLabelHeight),

            alreadyFollowedTableView.topAnchor.constraint(equalTo: alreadyFollowedLabel.bottomAnchor),
            alreadyFollowedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            alreadyFollowedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            addFollowerGreetingLabel.topAnchor.constraint(equalTo: alreadyFollowedTableView.bottomAnchor, constant: UIConstants.addFollowedTableViewTopSpacing),
            addFollowerGreetingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.addFollowedLabelLeadingTrailingAnchor),
            addFollowerGreetingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -UIConstants.addFollowedLabelLeadingTrailingAnchor),

            addFollowersTableView.topAnchor.constraint(equalTo: addFollowerGreetingLabel.bottomAnchor, constant: UIConstants.addFollowedTableViewTopSpacing),
            addFollowersTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            addFollowersTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    private func getUsersToFollow() {
        StorageManager.shared.getDocumentInfo(by: nil) { [weak self] (users: [RegisteredUser]) in
            guard let strongRef = self else { return }
            strongRef.usersToFollow = users
            strongRef.usersToFollow.removeAll(where: {$0.login=="addavatar@some.com"})
            strongRef.usersToFollow.removeAll(where: {$0.login==strongRef.userLogged.login})
            strongRef.usersToFollow = strongRef.usersToFollow.filter { !strongRef.userLogged.meFollowing.contains($0.login) }
            if strongRef.usersToFollow.count > 0 {
                strongRef.addFollowerGreetingLabel.isHidden = false
            }
            strongRef.addFollowersTableView.reloadData()
            strongRef.updateTableViewHeights()
        }
    }
    
    private func getAlreadyFollowedUsers() {
        StorageManager.shared.getDocumentInfo(by: nil) { [weak self] (users: [RegisteredUser]) in
            guard let strongRef = self else { return }
            strongRef.alreadyFollowedUsers = users
            strongRef.alreadyFollowedUsers.removeAll(where: {$0.login=="addavatar@some.com"})
            strongRef.alreadyFollowedUsers.removeAll(where: {$0.login==strongRef.userLogged.login})
            strongRef.alreadyFollowedUsers = strongRef.alreadyFollowedUsers.filter { strongRef.userLogged.meFollowing.contains($0.login) }
            
            if strongRef.alreadyFollowedUsers.count > 0 {
                strongRef.alreadyFollowedLabel.text = NSLocalizedString("alreadyFollowedLabel", comment: "")
                strongRef.alreadyFollowedLabel.isHidden = false
            } else {
                strongRef.alreadyFollowedLabel.text = NSLocalizedString("notFollowingAnybodyLabel", comment: "")
                strongRef.alreadyFollowedLabel.isHidden = false
            }
            
            strongRef.alreadyFollowedTableView.reloadData()
            strongRef.updateTableViewHeights()
        }
    }
    
    @objc func addFollowedUser(_ gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: addFollowersTableView)
        if let tappedIndexPath = addFollowersTableView.indexPathForRow(at: tapLocation) {
            
            StorageManager.shared.saveFollower(for: userLogged, follower: usersToFollow[tappedIndexPath.row])
            self.dismiss(animated: true)
            
            userLogged.meFollowing.append(usersToFollow[tappedIndexPath.row].login)
            delegate?.changeFollowedUsers(for: userLogged, remove: false, with: usersToFollow[tappedIndexPath.row])
        }
    }

    private func updateTableViewHeights() {
        addFollowersTableView.layoutIfNeeded()
        alreadyFollowedTableView.layoutIfNeeded()
        
        addFollowersTableViewHeightConstraint?.constant = addFollowersTableView.contentSize.height
        alreadyFollowedTableViewHeightConstraint?.constant = alreadyFollowedTableView.contentSize.height

            
        UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
        }
    }
}

extension AddFollowedVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.self == self.addFollowersTableView {
            return usersToFollow.count
        }
        else if tableView.self == self.alreadyFollowedTableView {
            return alreadyFollowedUsers.count
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.self == alreadyFollowedTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddFollowerTableViewCell.cellID, for: indexPath) as? AddFollowerTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCell(for: alreadyFollowedUsers[indexPath.row])
            return cell
        } else if tableView.self == addFollowersTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: AddFollowerTableViewCell.cellID, for: indexPath) as? AddFollowerTableViewCell else {
                return UITableViewCell()
            }
            cell.configureCell(for: usersToFollow[indexPath.row])
            return cell
        }
        else
        {
            return UITableViewCell()
        }
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.self == alreadyFollowedTableView {
            return 70
        }
        else if tableView.self == addFollowersTableView {
            return 70
        }
        else {
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            if tableView == self.addFollowersTableView {
                return .none
            } else if tableView == self.alreadyFollowedTableView {
                return .delete
            }
            return .none
        }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if tableView.self == alreadyFollowedTableView {
            if editingStyle == .delete {
                StorageManager.shared.deleteFollower(for: userLogged, follower: alreadyFollowedUsers[indexPath.row])
                self.dismiss(animated: true)
                userLogged.meFollowing.removeAll(where: {$0 == alreadyFollowedUsers[indexPath.row].login})
                delegate?.changeFollowedUsers(for: userLogged, remove: true, with: alreadyFollowedUsers[indexPath.row])
            }
    }
}
}
