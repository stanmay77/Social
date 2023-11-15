import UIKit

class LoginVC: UIViewController {
    
    var viewModel: LoginViewModel
    
    lazy var entryHeaderView = EntryHeaderView()
    
    lazy var loginButton = SocialButton(frame: .zero, buttonColor: UIColor(named: "buttonColor")!, textColor: UIColor.antimonochrome, buttonText: NSLocalizedString("loginLabel", comment: "")) {
        
        var email = self.loginField.text ?? ""
        var password = self.passwordField.text ?? ""
        
        self.viewModel.updateState(input: .userCredentialsInput((email, password)))
        self.viewModel.onStateChanged = { [self] state in
            
            switch state {
            case .logged(let user):
                let vc = CoreTabVC(userLogged: user)
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: true)
                
            case .notlogged(let error):
                print("Not logged")
                if error != nil {
                    let alertVC = UIAlertController(title: NSLocalizedString("errorAlertTitle", comment: ""), message: error!.localizedAuthError, preferredStyle: .alert)
                    let action = UIAlertAction(title: NSLocalizedString("errorAlertAction", comment: ""), style: .cancel)
                    alertVC.addAction(action)
                    present(alertVC, animated: true)
                }
            }
        }
    }
    
    lazy var signUpLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("signUpLabel", comment: "")
        label.textColor = UIColor(named: "monochrome")
        label.textAlignment = .center
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapSignUp))
        label.addGestureRecognizer(gestureRecognizer)
        label.isUserInteractionEnabled = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var appNameLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("appNameLabel", comment: "")
        label.font = UIFont(name: "Morethan50.000", size: 64)
        label.textColor = UIColor(named: "monochrome")
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var loginField = SocialNewTextField(frame: .zero, passwordField: false, placeholderText: NSLocalizedString("loginTextFieldPlaceholder", comment: ""), inputText: "stan@google.com")
    
    lazy var passwordField = SocialNewTextField(frame: .zero, passwordField: true, placeholderText: NSLocalizedString("passwordTextFieldPlaceholder", comment: ""), inputText: "111111")

    
    lazy var scrollVew: UIScrollView = {
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
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
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
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollVew)
        scrollVew.addSubview(scrollContentView)
        scrollContentView.addSubview(entryHeaderView)
        scrollContentView.addSubview(appNameLabel)
        scrollContentView.addSubview(loginField)
        scrollContentView.addSubview(passwordField)
        scrollContentView.addSubview(loginButton)
        scrollContentView.addSubview(signUpLabel)
        
        //Special case: if placeholders are set - the login button is active - for convinience of testing othw inacrive till user enters login and password
        
        if (loginField.placeholder != "" && passwordField.placeholder != "") {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
        
        loginField.addTarget(self, action: #selector(finishEditing), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(finishEditing), for: .editingChanged)
        
        loginField.delegate = self
        passwordField.delegate = self
        
        NSLayoutConstraint.activate([
            scrollVew.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollVew.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollVew.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollVew.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

            scrollContentView.topAnchor.constraint(equalTo: scrollVew.topAnchor),
            scrollContentView.leadingAnchor.constraint(equalTo: scrollVew.leadingAnchor),
            scrollContentView.trailingAnchor.constraint(equalTo: scrollVew.trailingAnchor),
            scrollContentView.widthAnchor.constraint(equalTo: scrollVew.widthAnchor),
            scrollContentView.bottomAnchor.constraint(equalTo: scrollVew.bottomAnchor),

            entryHeaderView.topAnchor.constraint(equalTo: scrollContentView.topAnchor, constant: UIConstants.loginEntryHeaderTopSpacing),
            entryHeaderView.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),
            entryHeaderView.widthAnchor.constraint(equalToConstant: UIConstants.loginEntryHeaderSize),
            entryHeaderView.heightAnchor.constraint(equalToConstant: UIConstants.loginEntryHeaderSize),

            appNameLabel.topAnchor.constraint(equalTo: entryHeaderView.bottomAnchor, constant: UIConstants.loginAppNameLabelTopSpacing),
            appNameLabel.centerXAnchor.constraint(equalTo: scrollContentView.centerXAnchor),

            loginField.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: UIConstants.loginFieldTopSpacing),
            loginField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: UIConstants.loginFieldLeadingTrailingSpacing),
            loginField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -UIConstants.loginFieldLeadingTrailingSpacing),
            loginField.heightAnchor.constraint(equalToConstant: UIConstants.loginFieldHeight),

            passwordField.topAnchor.constraint(equalTo: loginField.bottomAnchor, constant: UIConstants.passwordFieldTopSpacing),
            passwordField.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: UIConstants.loginFieldLeadingTrailingSpacing),
            passwordField.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -UIConstants.loginFieldLeadingTrailingSpacing),
            passwordField.heightAnchor.constraint(equalToConstant: UIConstants.loginFieldHeight),

            loginButton.heightAnchor.constraint(equalToConstant: UIConstants.loginButtonHeight),
            loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: UIConstants.loginButtonTopSpacing),
            loginButton.leadingAnchor.constraint(equalTo: scrollContentView.leadingAnchor, constant: UIConstants.loginFieldLeadingTrailingSpacing),
            loginButton.trailingAnchor.constraint(equalTo: scrollContentView.trailingAnchor, constant: -UIConstants.loginFieldLeadingTrailingSpacing),

            signUpLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: UIConstants.signUpLabelTopSpacing),
            signUpLabel.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
            signUpLabel.heightAnchor.constraint(equalToConstant: UIConstants.signUpLabelHeight),

            signUpLabel.bottomAnchor.constraint(equalTo: scrollContentView.bottomAnchor, constant: UIConstants.signUpLabelBottomSpacing)
        ])
        
        
        
        animateLabel()
    }
    
    
    func animateLabel() {
        UIView.animate(withDuration: 3, delay: 0.5, options: .curveEaseOut) {
            self.appNameLabel.alpha = 1
        }
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
    
    @objc func willShowKeyboard(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height+2.5*loginButton.frame.height, right: 0)
            scrollVew.contentInset = insets
            scrollVew.scrollIndicatorInsets = insets
            
        }
    }
    
    @objc func willHideKeyboard(_ notification: NSNotification) {
        scrollVew.contentInset = .zero
        scrollVew.scrollIndicatorInsets = .zero
    }
    
    private func removeKeyboardObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func tapSignUp() {
        print("Tapped")
        let vc = SignUpVC()
        present(vc, animated: true)
    }
    
    @objc func finishEditing() {
        loginButton.isEnabled = (!loginField.text!.isEmpty && !passwordField.text!.isEmpty)
    }
    
}

extension LoginVC: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}
