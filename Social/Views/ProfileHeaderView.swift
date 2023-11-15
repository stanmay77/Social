import UIKit


// Class to visualize profile header in Profile VC

final class ProfileHeaderView: UIView {

    var userLogged: RegisteredUser
    
    // Delegate to trigger vc presentation, when profile button is clicked
    weak var delegate: ProfileButtonsDelegate?
    
    lazy var avatarView = AvatarImageView(frame: CGRect(x: 0, y: 0, width: UIConstants.profileHeaderAvatarSize, height: UIConstants.profileHeaderAvatarSize), bWidth: 0)
    
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = userLogged.fullName
        label.font = UIFont.systemFont(ofSize: UIConstants.nameLabelFontSize, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var cityLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = userLogged.city
        label.font = UIFont.systemFont(ofSize: UIConstants.cityLabelFontSize)
        label.textColor = .systemGray2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var profileStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(self.nameLabel)
        stackView.addArrangedSubview(self.cityLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var editProfileButton = SocialButton(frame: .zero, buttonColor: UIColor(named: "orangeTabTintColor")!, textColor: UIColor.antimonochrome, buttonText: NSLocalizedString("editProfileButtonLabel", comment: "")) {
        self.delegate?.didTapEditUser(for: self.userLogged)
    }
    
    
    lazy var divider = Divider(frame: .zero, separatorColor: .systemGray3)
    
    lazy var newPostLabel = VerticalImageLabelView(frame: .zero, image: UIImage(systemName: "square.and.pencil.circle")!, text: NSLocalizedString("newPostButtonLabel", comment: "")) {
        self.delegate?.didTapNewPost(for: self.userLogged)
    }
    
    lazy var profileStatisticsView = ProfileStatisticsView(frame: .zero, userLogged: userLogged)
    
    lazy var locationsLabel = VerticalImageLabelView(frame: .zero, image: UIImage(systemName: "safari")!, text: NSLocalizedString("locationsProfileButton", comment: "")) {
        self.delegate?.didTapLocations(for: self.userLogged)
    }

    lazy var photosLabel = VerticalImageLabelView(frame: .zero, image: UIImage(systemName: "photo.circle")!, text: NSLocalizedString("photosProfileButton", comment: "")) {
        self.delegate?.didTapPhotos(for: self.userLogged)
    }
    
    
        
    init(userLogged: RegisteredUser) {
        self.userLogged = userLogged
        super.init(frame: .zero)
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: NSNotification.Name("updatedUser"), object: nil)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        
        backgroundColor = .systemBackground
        addSubview(avatarView)
        addSubview(profileStackView)
        addSubview(editProfileButton)
        addSubview(profileStatisticsView)
        addSubview(divider)
        addSubview(newPostLabel)
        addSubview(photosLabel)
        addSubview(locationsLabel)
        
        
        CloudStorageManager.shared.fetchCloudImage(for: URL(string: self.userLogged.avatarURL!)!) { result in
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
        
        
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            avatarView.widthAnchor.constraint(equalToConstant: 75),
            avatarView.heightAnchor.constraint(equalToConstant: 75),
            
            profileStackView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            profileStackView.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 15),
            profileStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            profileStackView.heightAnchor.constraint(equalToConstant: 75),
            
            editProfileButton.topAnchor.constraint(equalTo: profileStackView.bottomAnchor, constant: 15),
            editProfileButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            editProfileButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            editProfileButton.heightAnchor.constraint(equalToConstant: 50),
            
            profileStatisticsView.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 7),
            profileStatisticsView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            profileStatisticsView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            profileStatisticsView.heightAnchor.constraint(equalToConstant: 50),
            
            divider.topAnchor.constraint(equalTo: profileStatisticsView.bottomAnchor, constant: 3),
            divider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            divider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            divider.heightAnchor.constraint(equalToConstant: 1),
            
            newPostLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            newPostLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            newPostLabel.widthAnchor.constraint(equalToConstant: 50),
            newPostLabel.heightAnchor.constraint(equalToConstant: 50),
            
            locationsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            locationsLabel.centerYAnchor.constraint(equalTo: newPostLabel.centerYAnchor),
            locationsLabel.widthAnchor.constraint(equalToConstant: 50),
            locationsLabel.heightAnchor.constraint(equalToConstant: 50),
            
            photosLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 10),
            photosLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            photosLabel.widthAnchor.constraint(equalToConstant: 50),
            photosLabel.heightAnchor.constraint(equalToConstant: 50)
 
        ])
    }
    
    @objc func updateView() {
        self.nameLabel.text = userLogged.fullName
        self.cityLabel.text = userLogged.city
        print("New name: \(userLogged.fullName)")
        self.profileStatisticsView.userLogged = userLogged
        self.profileStatisticsView.updateView()
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
}
