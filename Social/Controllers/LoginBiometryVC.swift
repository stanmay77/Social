import UIKit

// VC for biometry login

class LoginBiometryVC: UIViewController {
    
    var userLogged: RegisteredUser
    
    init(userLogged: RegisteredUser) {
        self.userLogged = userLogged
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var entryHeaderView = EntryHeaderView()
    
    lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("appNameLabel", comment: "")
        label.font = UIFont(name: "Morethan50.000", size: 64)
        label.textColor = UIColor(named: "monochrome")
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var faceIDImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "faceid")
        imageView.tintColor = UIColor.orangeTabTint
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        authWithBiometrics()
    }
    
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(entryHeaderView)
        view.addSubview(appNameLabel)
        view.addSubview(faceIDImageView)
        
        
        NSLayoutConstraint.activate([
            entryHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.entryHeaderViewTopSpacing),
            entryHeaderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            entryHeaderView.widthAnchor.constraint(equalToConstant: UIConstants.entryHeaderViewSize),
            entryHeaderView.heightAnchor.constraint(equalToConstant: UIConstants.entryHeaderViewSize),
            
            appNameLabel.topAnchor.constraint(equalTo: entryHeaderView.bottomAnchor, constant: UIConstants.appNameLabelTopSpacing),
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            faceIDImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            faceIDImageView.heightAnchor.constraint(equalToConstant: UIConstants.faceIDImageViewSize),
            faceIDImageView.widthAnchor.constraint(equalToConstant: UIConstants.faceIDImageViewSize),
            faceIDImageView.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: UIConstants.faceIDImageViewTopSpacing)
        ])
        
        
        animateLabel()
    
    }
    
    
    func animateLabel() {
        UIView.animate(withDuration: 3, delay: 0.5, options: .curveEaseOut) {
            self.appNameLabel.alpha = 1
        }
    }
    
    func authWithBiometrics() {
        BiometryAuthManager.shared.authorizeIfPossible { [self] authResult in
            switch authResult {
            case true:
                DispatchQueue.main.async {
                    let vc = CoreTabVC(userLogged: self.userLogged)
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                }
            case false:
                return
            }
        }
    }
    
}
