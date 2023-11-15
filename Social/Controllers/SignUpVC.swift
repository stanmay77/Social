import UIKit
import MobileCoreServices

// Sign Up user VC

class SignUpVC: UIViewController {
    
    private var avatarURL: URL? = nil
      
    lazy var logInSignUpField = SocialNewTextField(frame: .zero, passwordField: false, placeholderText: NSLocalizedString("loginTextFieldPlaceholder", comment:""), inputText: nil)
    
    lazy var passwordSignUpField = SocialNewTextField(frame: .zero, passwordField: true, placeholderText: NSLocalizedString("passwordTextFieldPlaceholder", comment:""), inputText: nil)
    
    lazy var confirmPasswordField = SocialNewTextField(frame: .zero, passwordField: true, placeholderText: NSLocalizedString("confirmPasswordSignUpPlaceholder", comment:""), inputText: nil)
    
    lazy var profileDetailsView = ProfileDetailsEditView(isEditable: true)
    
 
    lazy var signUpLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("signUpLabelText", comment:"")
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = UIColor(named: "monochrome")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    
    lazy var avatarImageView = AvatarImageView(frame: CGRect(x: 100, y: 100, width: 100, height: 100), bWidth: 2)
    
    lazy var profileLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("profileLabelText", comment:"")
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = UIColor(named: "monochrome")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    lazy var passwordConfirmationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("passwordConfirmationLabelText", comment:"")
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    

    lazy var scrollSignUpContentView: UIView = {
         let view = UIView()
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
     
     
     lazy var signUpScrollView: UIScrollView = {
         let view = UIScrollView(frame: .zero)
         view.isScrollEnabled = true
         view.showsVerticalScrollIndicator = true
         view.showsHorizontalScrollIndicator = false
         view.translatesAutoresizingMaskIntoConstraints = false
         return view
     }()
    
    
    lazy var signUpButton = SocialButton(frame: .zero, buttonColor: UIColor(named: "buttonColor")!, textColor: UIColor(named: "antimonochrome")!, buttonText: NSLocalizedString("signUpLabel", comment:"")) { [unowned self] in
        
        AuthManager.shared.signUpUser(with: logInSignUpField.text!, password: passwordSignUpField.text!) { [self] result in
            
            switch result {
            case .success(let result):
                  
                CloudStorageManager.shared.uploadImageToCloud(for: avatarURL!, for: logInSignUpField.text!, avatar: true) { [self] result in
                        switch result {
                        case .success(let url):
                            StorageManager.shared.saveDocumentInfo(for: RegisteredUser(login: self.logInSignUpField.text!, fullName: self.profileDetailsView.nameSignUpField.text ?? "", avatarURL: url.absoluteString, city: self.profileDetailsView.citySignUpField.text ?? "", occupation: profileDetailsView.occupationSignUpField.text ?? "", posts: 0, subscriptions: 0, followers: 0, followedBy: ["addavatar@some.com"], meFollowing: ["addavatar@some.com"], userPhotos: [])) { result in
                            }
                        case .failure(let error):
                            let alertVC = UIAlertController(title: NSLocalizedString("errorAlertTitle", comment: ""), message: error.localizedSignUpError, preferredStyle: .alert)
                            let alertAction = UIAlertAction(title: NSLocalizedString("errorAlertAction", comment: ""), style: .default)
                            alertVC.addAction(alertAction)
                            present(alertVC, animated: true)
                        }
                    }

  
                let alertVC = UIAlertController(title: NSLocalizedString("successAlertTitle", comment: ""), message: NSLocalizedString("userRegisteredAlertText", comment: ""), preferredStyle: .alert)
                let alertAction = UIAlertAction(title: NSLocalizedString("okAlertButtonTitle", comment: ""), style: .default) { _ in
                    self.dismiss(animated: true)
                }
                alertVC.addAction(alertAction)
                present(alertVC, animated: true)
                
            case .failure(let error):
                let alertVC = UIAlertController(title: NSLocalizedString("errorAlertTitle", comment: ""), message: error.localizedSignUpError, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: NSLocalizedString("errorAlertAction", comment: ""), style: .default)
                alertVC.addAction(alertAction)
                present(alertVC, animated: true)
            }
        }
    }
    
    lazy var uploadPhotoLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("profileUploadPhotoLabel", comment:"")
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .regular)
        label.textColor = UIColor(named: "monochrome")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    
    lazy var uploadPhotoButton = SocialButton(frame: .zero, buttonColor: UIColor(named: "buttonColor")!, textColor: UIColor(named: "antimonochrome")!, buttonText: NSLocalizedString("uploadPhotoButtonLabel", comment: "")) { [unowned self] in

        let imageMediaType = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [imageMediaType]
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let baseURL = Bundle.main.url(forResource: "uploadAvatar", withExtension: "jpeg") {
            self.avatarURL = baseURL
        }
        
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
    
    func configureUI() {
        navigationController?.navigationBar.isHidden = false
        
        title = "Sign Up"
        view.backgroundColor = .systemBackground
        
        logInSignUpField.addTarget(self, action: #selector(finishEditing), for: .editingChanged)
        passwordSignUpField.addTarget(self, action: #selector(finishEditing), for: .editingChanged)
        confirmPasswordField.addTarget(self, action: #selector(passwordConfirmed), for: .editingChanged)
        passwordConfirmationLabel.isHidden = true
        signUpButton.isEnabled = false
        
    
        
        view.addSubview(signUpScrollView)
        signUpScrollView.addSubview(scrollSignUpContentView)
        scrollSignUpContentView.addSubview(logInSignUpField)
        scrollSignUpContentView.addSubview(passwordSignUpField)
        scrollSignUpContentView.addSubview(confirmPasswordField)
        scrollSignUpContentView.addSubview(profileDetailsView)
        scrollSignUpContentView.addSubview(signUpLabel)
        scrollSignUpContentView.addSubview(profileLabel)
        scrollSignUpContentView.addSubview(signUpButton)
        scrollSignUpContentView.addSubview(uploadPhotoLabel)
        scrollSignUpContentView.addSubview(passwordConfirmationLabel)
        scrollSignUpContentView.addSubview(avatarImageView)
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapLoadAvatar))
        avatarImageView.addGestureRecognizer(gestureRecognizer)
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.image = UIImage.uploadAvatar
        
        NSLayoutConstraint.activate([
            signUpScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            signUpScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            signUpScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            signUpScrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            scrollSignUpContentView.topAnchor.constraint(equalTo: signUpScrollView.topAnchor),
            scrollSignUpContentView.widthAnchor.constraint(equalTo: signUpScrollView.widthAnchor),
            scrollSignUpContentView.heightAnchor.constraint(equalTo: signUpScrollView.heightAnchor),
            scrollSignUpContentView.bottomAnchor.constraint(equalTo: signUpScrollView.bottomAnchor),
            scrollSignUpContentView.leadingAnchor.constraint(equalTo: signUpScrollView.leadingAnchor),
            scrollSignUpContentView.trailingAnchor.constraint(equalTo: signUpScrollView.trailingAnchor),
            
            signUpLabel.topAnchor.constraint(equalTo: scrollSignUpContentView.topAnchor, constant: UIConstants.signUpTitleLabelTopSpacing),
            signUpLabel.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor, constant: UIConstants.signUpLabelLeadingTrailingSpacing),
            signUpLabel.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor, constant: -UIConstants.signUpLabelLeadingTrailingSpacing),
            
            logInSignUpField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight),
            logInSignUpField.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor, constant: UIConstants.textFieldLeadingTrailingSpacing),
            logInSignUpField.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor, constant: -UIConstants.textFieldLeadingTrailingSpacing),
            logInSignUpField.topAnchor.constraint(equalTo: signUpLabel.bottomAnchor, constant: UIConstants.textFieldTopSpacing),
            
            passwordSignUpField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight),
            passwordSignUpField.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor, constant: UIConstants.textFieldLeadingTrailingSpacing),
            passwordSignUpField.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor, constant: -UIConstants.textFieldLeadingTrailingSpacing),
            passwordSignUpField.topAnchor.constraint(equalTo: logInSignUpField.bottomAnchor, constant: UIConstants.textFieldTopSpacing),
            
            confirmPasswordField.heightAnchor.constraint(equalToConstant: UIConstants.textFieldHeight),
            confirmPasswordField.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor, constant: UIConstants.textFieldLeadingTrailingSpacing),
            confirmPasswordField.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor, constant: -UIConstants.textFieldLeadingTrailingSpacing),
            confirmPasswordField.topAnchor.constraint(equalTo: passwordSignUpField.bottomAnchor, constant: UIConstants.textFieldTopSpacing),
            
            passwordConfirmationLabel.heightAnchor.constraint(equalToConstant: UIConstants.passwordConfirmationLabelHeight),
            passwordConfirmationLabel.topAnchor.constraint(equalTo: confirmPasswordField.bottomAnchor, constant: UIConstants.passwordConfirmationLabelTopSpacing),
            passwordConfirmationLabel.widthAnchor.constraint(equalToConstant: UIConstants.uploadPhotoLabelWidth),
            passwordConfirmationLabel.centerXAnchor.constraint(equalTo: scrollSignUpContentView.centerXAnchor),
            
            profileLabel.topAnchor.constraint(equalTo: passwordConfirmationLabel.bottomAnchor, constant: UIConstants.profileLabelTopSpacing),
            profileLabel.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor, constant: UIConstants.signUpLabelLeadingTrailingSpacing),
            profileLabel.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor, constant: -UIConstants.signUpLabelLeadingTrailingSpacing),
            
            profileDetailsView.topAnchor.constraint(equalTo: profileLabel.bottomAnchor),
            profileDetailsView.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor),
            profileDetailsView.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor),
            profileDetailsView.heightAnchor.constraint(equalToConstant: UIConstants.signUpProfileDetailsViewHeight),
            
            uploadPhotoLabel.topAnchor.constraint(equalTo: profileDetailsView.bottomAnchor, constant: UIConstants.uploadPhotoLabelTopSpacing),
            uploadPhotoLabel.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor, constant: UIConstants.signUpLabelLeadingTrailingSpacing),
            uploadPhotoLabel.widthAnchor.constraint(equalToConstant: UIConstants.uploadPhotoLabelWidth),
            
            signUpButton.heightAnchor.constraint(equalToConstant: UIConstants.signUpButtonHeight),
            signUpButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: UIConstants.signUpButtonTopSpacing),
            signUpButton.leadingAnchor.constraint(equalTo: scrollSignUpContentView.leadingAnchor, constant: UIConstants.textFieldLeadingTrailingSpacing),
            signUpButton.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor, constant: -UIConstants.textFieldLeadingTrailingSpacing),
            
            avatarImageView.heightAnchor.constraint(equalToConstant: UIConstants.avatarImageViewSize),
            avatarImageView.widthAnchor.constraint(equalToConstant: UIConstants.avatarImageViewSize),
            avatarImageView.centerYAnchor.constraint(equalTo: uploadPhotoLabel.centerYAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: scrollSignUpContentView.trailingAnchor, constant: UIConstants.avatarImageViewTrailingSpacing)
        ])
        
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
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height
        if signUpScrollView.contentInset.bottom == 0 {
            signUpScrollView.contentInset.bottom += keyboardHeight ?? 0.0
        }
     
        
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        signUpScrollView.contentInset.bottom = 0.0
    }
    
    @objc func finishEditing() {
        signUpButton.isEnabled = !logInSignUpField.text!.isEmpty && !passwordSignUpField.text!.isEmpty
        uploadPhotoButton.isEnabled = !logInSignUpField.text!.isEmpty && !passwordSignUpField.text!.isEmpty

    }
    
    @objc func passwordConfirmed() {
        
        if passwordSignUpField.text! == confirmPasswordField.text! || (passwordSignUpField.text!.isEmpty || confirmPasswordField.text!.isEmpty)
        {
            passwordConfirmationLabel.isHidden = true
            signUpButton.isEnabled = true
            uploadPhotoButton.isEnabled = true
        }
        else {
            passwordConfirmationLabel.isHidden = false
            signUpButton.isEnabled = false
            uploadPhotoButton.isEnabled = false
        }
    }
    
    @objc func tapLoadAvatar() {
        let imageMediaType = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [imageMediaType]
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if #available(iOS 13.0, *), traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            let avatarColor = UIColor.monochrome.cgColor
            avatarImageView.layer.borderColor = avatarColor
        }
    }
    
}


extension SignUpVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        do {
            let imageData = try Data(contentsOf: imageURL)
            avatarImageView.image = UIImage(data: imageData)
        }
        catch {
            print(error.localizedDescription)
        }
        
        self.avatarURL = imageURL
        
        picker.dismiss(animated: true)
        }
    }
