import UIKit

// VC to edit user profile

class EditUserVC: UIViewController {
    
    var userToEdit: RegisteredUser
    weak var delegate: NewPostDelegate?
    var isEditable: Bool
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.isScrollEnabled = true
        scroll.showsVerticalScrollIndicator = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    lazy var scrollContentView: UIView = {
        let scrollContent = UIView(frame: .zero)
        scrollContent.translatesAutoresizingMaskIntoConstraints = false
        return scrollContent
    }()
    
    
    lazy var avatarView = AvatarImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), bWidth: 1)
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = userToEdit.fullName
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var divider = Divider(frame: .zero, separatorColor: UIColor.orangeTabTint)
   
    lazy var editUserGreetingLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = isEditable ? NSLocalizedString("editUserGreetingLabel", comment: "") : NSLocalizedString("viewUserGreetingLabel", comment: "")
        label.textColor = .monochrome
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var profileDetailsView = ProfileDetailsEditView(isEditable: isEditable)
    
    lazy var proceedButton = SocialButton(frame: .zero, buttonColor: UIColor(named: "buttonColor")!, textColor: UIColor(named: "antimonochrome")!, buttonText: isEditable ? NSLocalizedString("saveEditingButtonLabel", comment:"") : NSLocalizedString("closeLabel", comment:"")) { [unowned self] in
        
        if self.isEditable {
            
            StorageManager.shared.updateDocument(by: userToEdit.login, fields: ["city": profileDetailsView.citySignUpField.text ?? "", "occupation": profileDetailsView.occupationSignUpField.text ?? "", "fullName": profileDetailsView.nameSignUpField.text ?? ""]) {
                (user: [RegisteredUser]) in
            }
            
            userToEdit.fullName = profileDetailsView.nameSignUpField.text ?? ""
            userToEdit.city = profileDetailsView.citySignUpField.text ?? ""
            userToEdit.occupation = profileDetailsView.occupationSignUpField.text ?? ""
            delegate?.updateCurrentUser(using: userToEdit)
            self.dismiss(animated: true)
        }
        else {
            self.dismiss(animated: true)
        }
        
    }
    
    init(userToEdit: RegisteredUser, isEditable: Bool) {
        self.userToEdit = userToEdit
        self.isEditable = isEditable
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
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        
        scrollContentView.addSubview(avatarView)
        scrollContentView.addSubview(userNameLabel)
        scrollContentView.addSubview(divider)
        scrollContentView.addSubview(editUserGreetingLabel)
        scrollContentView.addSubview(profileDetailsView)
        scrollContentView.addSubview(proceedButton)
        
        profileDetailsView.citySignUpField.text = userToEdit.city
        profileDetailsView.nameSignUpField.text = userToEdit.fullName
        profileDetailsView.occupationSignUpField.text = userToEdit.occupation
        
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            avatarView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: UIConstants.editUserAvatarTopSpacing),
            avatarView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: UIConstants.editUserAvatarLeadingSpacing),
            avatarView.widthAnchor.constraint(equalToConstant: UIConstants.editUserAvatarSize),
            avatarView.heightAnchor.constraint(equalToConstant: UIConstants.editUserAvatarSize),
            
            userNameLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: UIConstants.editUserNameLabelLeadingSpacing),
            userNameLabel.widthAnchor.constraint(equalToConstant: UIConstants.editUserNameLabelSize),
            userNameLabel.heightAnchor.constraint(equalToConstant: UIConstants.editUserNameLabelSize),
            
            divider.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: UIConstants.editUserDividerTopSpacing),
            divider.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: UIConstants.editUserAvatarLeadingSpacing),
            divider.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -UIConstants.editUserAvatarLeadingSpacing),
            divider.heightAnchor.constraint(equalToConstant: UIConstants.editUserDividerHeight),
            
            editUserGreetingLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: UIConstants.editUserGreetingLabelTopSpacing),
            editUserGreetingLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: UIConstants.editUserAvatarLeadingSpacing),
            editUserGreetingLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -UIConstants.editUserAvatarLeadingSpacing),
            editUserGreetingLabel.heightAnchor.constraint(equalToConstant: UIConstants.editUserGreetingLabelHeight),
            
            profileDetailsView.topAnchor.constraint(equalTo: editUserGreetingLabel.bottomAnchor, constant: UIConstants.profileDetailsViewTopSpacing),
            profileDetailsView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor),
            profileDetailsView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor),
            profileDetailsView.heightAnchor.constraint(equalToConstant: UIConstants.profileDetailsViewHeight),
            
            proceedButton.heightAnchor.constraint(equalToConstant: UIConstants.proceedButtonHeight),
            proceedButton.topAnchor.constraint(equalTo: profileDetailsView.bottomAnchor, constant: UIConstants.proceedButtonTopSpacing),
            proceedButton.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: UIConstants.editUserAvatarLeadingSpacing),
            proceedButton.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -UIConstants.editUserAvatarLeadingSpacing),
        ])
        
        CloudStorageManager.shared.fetchCloudImage(for: URL(string: self.userToEdit.avatarURL!)!) {  result in
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
        
    }
    
    
    
}

