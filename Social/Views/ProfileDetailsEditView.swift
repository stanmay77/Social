import UIKit

// Profile edit view for sign up and edit user vcs

final class ProfileDetailsEditView: UIView {
    
    var isEditable: Bool
    
    lazy var nameSignUpField = SocialNewTextField(frame: .zero, passwordField: false, placeholderText: NSLocalizedString("yourNameSignUpPlaceholder", comment:""), inputText: nil)
    
    lazy var citySignUpField = SocialNewTextField(frame: .zero, passwordField: false, placeholderText: NSLocalizedString("yourCitySignUpPlaceholder", comment:""), inputText: nil)
    
    lazy var occupationSignUpField = SocialNewTextField(frame: .zero, passwordField: false, placeholderText: NSLocalizedString("yourOccupationSignUpPlaceholder", comment:""), inputText: nil)
    
    
    init(isEditable: Bool) {
        self.isEditable = isEditable
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        
        nameSignUpField.isEnabled = isEditable
        citySignUpField.isEnabled = isEditable
        occupationSignUpField.isEnabled = isEditable
        
        addSubview(nameSignUpField)
        addSubview(citySignUpField)
        addSubview(occupationSignUpField)
        
        NSLayoutConstraint.activate([
            nameSignUpField.heightAnchor.constraint(equalToConstant: UIConstants.signUpFieldHeight),
            nameSignUpField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.signUpFieldLeadingSpacing),
            nameSignUpField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: UIConstants.signUpFieldTrailingSpacing),
            nameSignUpField.topAnchor.constraint(equalTo: topAnchor, constant: UIConstants.signUpFieldTopSpacing),
            
            citySignUpField.heightAnchor.constraint(equalToConstant: UIConstants.signUpFieldHeight),
            citySignUpField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.signUpFieldLeadingSpacing),
            citySignUpField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: UIConstants.signUpFieldTrailingSpacing),
            citySignUpField.topAnchor.constraint(equalTo: nameSignUpField.bottomAnchor, constant: UIConstants.signUpFieldTopSpacing),
            
            occupationSignUpField.heightAnchor.constraint(equalToConstant: UIConstants.signUpFieldHeight),
            occupationSignUpField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: UIConstants.signUpFieldLeadingSpacing),
            occupationSignUpField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: UIConstants.signUpFieldTrailingSpacing),
            occupationSignUpField.topAnchor.constraint(equalTo: citySignUpField.bottomAnchor, constant: UIConstants.signUpFieldTopSpacing),
            
        ])
        
    }
    
    
}
