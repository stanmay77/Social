import UIKit
import MobileCoreServices

class NewPostVC: UIViewController {
    weak var delegate: NewPostDelegate?
    var userLogged: RegisteredUser
    private var postImageURL: URL? = nil
    
    
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
    
    lazy var avatarView = AvatarImageView(frame: CGRect(x: 0, y: 0, width: UIConstants.newPostAvatarSize, height: UIConstants.newPostAvatarSize), bWidth: 1)
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        
        let greetingFont = UIFont.boldSystemFont(ofSize: UIConstants.newPostGreetingFontSize)
        let greetingAttributes: [NSAttributedString.Key: Any] = [.font: greetingFont]
        let greetingString = NSMutableAttributedString(string: NSLocalizedString("newPostGreetingLabel", comment: "") + userLogged.fullName+"!", attributes: greetingAttributes)
        greetingString.append(NSAttributedString(string: NSLocalizedString("newPostLabel", comment: "")))
        
        
        label.attributedText = greetingString
        
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var divider = Divider(frame: .zero, separatorColor: UIColor.orangeTabTint)
    
    lazy var newPostTitleField = SocialNewTextField(frame: .zero, passwordField: false, placeholderText: NSLocalizedString("newPostTitleLabel", comment:""), inputText: nil)
    
    lazy var newPostTextView = SocialTextView(frame: .zero)
    
    lazy var uploadPostImageLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("newPostUploadImageLabel", comment: "")
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .monochrome
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var uploadPostImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = UIImage(systemName: "photo.artframe.circle")
        image.tintColor = UIColor(named: "orangeUIColor")
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapUploadPostImage)))
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var postButton = SocialButton(frame: .zero, buttonColor: UIColor(named: "buttonColor")!, textColor: UIColor(named: "antimonochrome")!, buttonText: NSLocalizedString("newPostButtonLabel", comment:"")) { [unowned self] in
        
        
        if postImageURL != nil {
            CloudStorageManager.shared.uploadImageToCloud(for: postImageURL!, for: "", avatar: false) { [self] result in
                switch result {
                case .success(let url):
                    StorageManager.shared.saveDocumentInfo(for: Post(postTitle: newPostTitleField.text ?? "", postDate: Date(), postImage: url.absoluteString, postText: newPostTextView.text ?? "", likes: 0, likesByUser: [], author: userLogged.login, isFavoritePost: false)) { [self] result in
                        switch result {
                        case true:
                            StorageManager.shared.updateUserPostNumber(for: userLogged, number: +1)
                            userLogged.userPhotos.append(url.absoluteString)
                            StorageManager.shared.updateDocument(by: userLogged.login, fields: ["userPhotos": userLogged.userPhotos]) { (user: [RegisteredUser]) in }
                        
                            
                            userLogged.posts += 1
                            delegate?.updateCurrentUser(using: userLogged)
                            
                            let alertVC = UIAlertController(title: NSLocalizedString("successAlertTitle", comment: ""), message: NSLocalizedString("newPostAlertMessage", comment: ""), preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: NSLocalizedString("okAlertButtonTitle", comment: ""), style: .default) { _ in
                                self.dismiss(animated: true)
                            }
                            alertVC.addAction(alertAction)
                            
                            DispatchQueue.main.async {
                                self.present(alertVC, animated: true)
                            }
                            
                        case false:
                            print("error")
                        }
                    }
                case .failure(let error):
                    print("Error")
                }
            }
        } else {
            StorageManager.shared.saveDocumentInfo(for: Post(postTitle: newPostTitleField.text ?? "", postDate: Date(), postImage: "", postText: newPostTextView.text ?? "", likes: 0, likesByUser: [], author: userLogged.login, isFavoritePost: false)) { [self] result in
                switch result {
                case true:
                    StorageManager.shared.updateUserPostNumber(for: userLogged, number: +1)
                    userLogged.posts += 1
                    delegate?.updateCurrentUser(using: userLogged)
                    
                    let alertVC = UIAlertController(title: NSLocalizedString("successAlertTitle", comment: ""), message: NSLocalizedString("newPostAlertMessage", comment: ""), preferredStyle: .alert)
                    let alertAction = UIAlertAction(title: NSLocalizedString("okAlertButtonTitle", comment: ""), style: .default) { _ in
                        self.dismiss(animated: true)
                    }
                    alertVC.addAction(alertAction)
                    present(alertVC, animated: true)
                    
                case false:
                    print("Error")
                }
            }
        }


        
    }
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }
    
    private func setupKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willShowKeyboard(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        notificationCenter.addObserver(
            self,
            selector: #selector(self.willHideKeyboard(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(scrollContentView)
        scrollContentView.addSubview(avatarView)
        scrollContentView.addSubview(userNameLabel)
        scrollContentView.addSubview(divider)
        scrollContentView.addSubview(newPostTitleField)
        scrollContentView.addSubview(newPostTextView)
        scrollContentView.addSubview(uploadPostImageLabel)
        scrollContentView.addSubview(uploadPostImageView)
        scrollContentView.addSubview(postButton)
        newPostTextView.placeholder = NSLocalizedString("newPostTextLabel", comment: "")
        
        newPostTitleField.delegate = self
        newPostTitleField.addTarget(self, action: #selector(finishEditingTitle), for: .editingChanged)

        
        postButton.isEnabled = false
        newPostTextView.isEditable = false
        
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.newPostScrollViewTopAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.newPostScrollViewLeadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.newPostScrollViewTrailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: UIConstants.newPostScrollViewBottomAnchor),
            
            scrollContentView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: UIConstants.newPostScrollContentViewTopAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            scrollContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            avatarView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: UIConstants.newPostAvatarTopOffset),
            avatarView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: UIConstants.newPostAvatarLeadingOffset),
            avatarView.widthAnchor.constraint(equalToConstant: UIConstants.newPostAvatarSize),
            avatarView.heightAnchor.constraint(equalToConstant: UIConstants.newPostAvatarSize),
            
            userNameLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: UIConstants.newPostUserNameLabelOffset),
            userNameLabel.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: UIConstants.trailingStandardOffser),
            userNameLabel.heightAnchor.constraint(equalToConstant: UIConstants.newPostUserNameLabelHeight),
            
            divider.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: UIConstants.newPostDividerTopOffset),
            divider.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: UIConstants.newPostAvatarLeadingOffset),
            divider.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: UIConstants.trailingStandardOffser),
            divider.heightAnchor.constraint(equalToConstant: UIConstants.newPostDividerHeight),
            
            newPostTitleField.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: UIConstants.newPostTitleFieldTopOffset),
            newPostTitleField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: UIConstants.newPostAvatarLeadingOffset),
            newPostTitleField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: UIConstants.trailingStandardOffser),
            newPostTitleField.heightAnchor.constraint(equalToConstant: UIConstants.newPostTitleFieldHeight),
            
            newPostTextView.topAnchor.constraint(equalTo: newPostTitleField.bottomAnchor, constant: UIConstants.newPostTextViewTopOffset),
            newPostTextView.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: UIConstants.newPostAvatarLeadingOffset),
            newPostTextView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: UIConstants.trailingStandardOffser),
            newPostTextView.heightAnchor.constraint(equalToConstant: UIConstants.newPostTextViewHeight),
            
            uploadPostImageLabel.topAnchor.constraint(equalTo: newPostTextView.bottomAnchor, constant: UIConstants.newPostUploadImageViewTopOffset),
            uploadPostImageLabel.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: UIConstants.newPostAvatarLeadingOffset),
            uploadPostImageLabel.widthAnchor.constraint(equalToConstant: UIConstants.newPostUploadLabelWidth),
            uploadPostImageLabel.heightAnchor.constraint(equalToConstant: UIConstants.newPostUploadLabelHeight),
            
            uploadPostImageView.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: UIConstants.trailingStandardOffser),
            uploadPostImageView.widthAnchor.constraint(equalToConstant: UIConstants.newPostUploadImageViewSize),
            uploadPostImageView.heightAnchor.constraint(equalToConstant: UIConstants.newPostUploadImageViewSize),
            uploadPostImageView.centerYAnchor.constraint(equalTo: uploadPostImageLabel.centerYAnchor),
            
            postButton.topAnchor.constraint(equalTo: uploadPostImageView.bottomAnchor, constant: UIConstants.newPostButtonTopOffset),
            postButton.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: UIConstants.newPostAvatarLeadingOffset),
            postButton.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: UIConstants.trailingStandardOffser),
            postButton.heightAnchor.constraint(equalToConstant: UIConstants.newPostButtonHeight),
            postButton.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: UIConstants.newPostButtonBottomOffset)
        ])
        
        
        CloudStorageManager.shared.fetchCloudImage(for: URL(string: self.userLogged.avatarURL!)!) {  result in
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
    
    @objc func tapUploadPostImage() {
        let imageMediaType = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [imageMediaType]
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true)
    }
    
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: 2.2*keyboardSize.height+postButton.frame.height, right: 0)
            scrollView.contentInset = insets
            scrollView.scrollIndicatorInsets = insets
            
        }
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func finishEditingTitle() {
        postButton.isEnabled = !newPostTitleField.text!.isEmpty
        newPostTextView.isEditable = !newPostTitleField.text!.isEmpty
    }
    
}

extension NewPostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        do {
            let imageData = try Data(contentsOf: imageURL)
            uploadPostImageView.image = UIImage(data: imageData)
        }
        catch {
            print(error.localizedDescription)
        }
        
        self.postImageURL = imageURL
        picker.dismiss(animated: true)
        }
    }

extension NewPostVC: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}
