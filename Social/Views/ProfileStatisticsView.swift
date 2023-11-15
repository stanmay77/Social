import UIKit

// Class to summarize profile statistics - setting VerticalImageLabelView

final class ProfileStatisticsView: UIView {
    
    
    var userLogged: RegisteredUser
    
    lazy var postsLabel = VerticalLabelView(frame: .zero, number: self.userLogged.posts, baseLabel: NSLocalizedString("postsStatisticsLabel", comment: ""))
    lazy var subscriptionsLabel = VerticalLabelView(frame: .zero, number: self.userLogged.subscriptions, baseLabel: NSLocalizedString("subscribedStatisticsLabel", comment: ""))
    lazy var followersLabel = VerticalLabelView(frame: .zero, number: self.userLogged.followers, baseLabel: NSLocalizedString("followersStatisticsLabel", comment: ""))
    
    lazy var profileInfoStackView: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        stack.alignment = .center
        stack.addArrangedSubview(postsLabel)
        stack.addArrangedSubview(subscriptionsLabel)
        stack.addArrangedSubview(followersLabel)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    init(frame: CGRect, userLogged: RegisteredUser) {
        self.userLogged = userLogged
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        addSubview(profileInfoStackView)
        NSLayoutConstraint.activate([
            profileInfoStackView.topAnchor.constraint(equalTo: topAnchor),
            profileInfoStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileInfoStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            profileInfoStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateView() {
        self.postsLabel.number = userLogged.posts
        self.followersLabel.number = userLogged.followers
        self.subscriptionsLabel.number = userLogged.subscriptions
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }
    
    

}

