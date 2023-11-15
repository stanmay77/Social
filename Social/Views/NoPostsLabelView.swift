import UIKit

// No nosts label for PostsVC and ProfileVC

final class NoPostsLabelView: UIView {
    
    lazy var noPostsLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("noPostsLabel", comment: "")
        label.textColor = .systemGray3
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(noPostsLabel)
        
        NSLayoutConstraint.activate([
            noPostsLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            noPostsLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
}


