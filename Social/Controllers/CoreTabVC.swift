import UIKit

// Core VC for tab view


class CoreTabVC: UITabBarController {
    
    var userLogged: RegisteredUser
    
    init(userLogged: RegisteredUser) {
        self.userLogged = userLogged
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let navVC1 = UINavigationController(rootViewController: PostsVC(userLogged: userLogged))
        let navVC2 = UINavigationController(rootViewController: ProfileVC(userLogged: userLogged))
        let navVC3 = UINavigationController(rootViewController: FavoritesVC())
        
        navVC1.tabBarItem = UITabBarItem(title: NSLocalizedString("postsVCTitle", comment:"") , image: UIImage(systemName: "house"), tag: 1)
        navVC2.tabBarItem = UITabBarItem(title: NSLocalizedString("profileVCTitle", comment: ""), image: UIImage(systemName: "person.circle"), tag: 2)
        navVC3.tabBarItem = UITabBarItem(title: NSLocalizedString("favVCTitle", comment: ""), image: UIImage(systemName: "heart"), tag: 3)
        
        tabBar.tintColor = UIColor(named:"orangeTabTintColor")
        tabBar.unselectedItemTintColor = UIColor(named: "orangeTabDeselectedColor")
        
        setViewControllers([navVC1, navVC2, navVC3], animated: true)
    }
    
}
