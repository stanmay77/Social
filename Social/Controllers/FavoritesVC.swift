import UIKit

// Current user favorite posts VC

class FavoritesVC: UIViewController {

    
    
    var posts: [Post] {
        let postsCD = CoreDManager.shared.posts
        return postsCD.map({$0.toStruct()})
    }
    
    lazy var favTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.cellID)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateFavTable), name: NSNotification.Name("postFavored"), object: nil)
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = NSLocalizedString("favVCTitle", comment: "")
        
        view.addSubview(favTableView)
        
        favTableView.delegate = self
        favTableView.dataSource = self
        
        NSLayoutConstraint.activate([
            favTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            favTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
    }
    
    @objc func updateFavTable() {
        favTableView.reloadData()
    }
}

extension FavoritesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.cellID, for: indexPath) as? PostTableViewCell else { return UITableViewCell ()}
        
        cell.configureForPost(post: posts[indexPath.row])
        cell.postStatView.saveFavoritesImageView.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDManager.shared.deletePost(at: indexPath.row)
            favTableView.reloadData()
        }
    }
    
}
