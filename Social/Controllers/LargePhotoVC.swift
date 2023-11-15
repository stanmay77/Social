import UIKit


// Photo presentation VC

class LargePhotoVC: UIViewController {
    
    
    var imageToShow: UIImage? = nil {
        didSet {
            imageView.image = imageToShow
        }
    }
    
    var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = NSLocalizedString("yourPhotoLabel", comment: "")
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var titleImage: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.image = UIImage(systemName: "photo.artframe.circle")
        image.tintColor = UIColor.orangeTabTint
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var divider = Divider(frame: .zero, separatorColor: UIColor.orangeTabTint)
    
    lazy var imageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(imageView)
        view.addSubview(titleImage)
        view.addSubview(titleLabel)
        view.addSubview(divider)
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            titleImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIConstants.largePhotoTitleImageTopSpacing),
            titleImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.largePhotoTitleImageLeadingSpacing),
            titleImage.heightAnchor.constraint(equalToConstant: UIConstants.largePhotoTitleImageSize),
            titleImage.widthAnchor.constraint(equalToConstant: UIConstants.largePhotoTitleImageSize),

            titleLabel.leadingAnchor.constraint(equalTo: titleImage.trailingAnchor, constant: UIConstants.largePhotoTitleLabelLeadingSpacing),
            titleLabel.widthAnchor.constraint(equalToConstant: UIConstants.largePhotoTitleLabelWidth),
            titleLabel.heightAnchor.constraint(equalToConstant: UIConstants.largePhotoTitleLabelHeight),
            titleLabel.centerYAnchor.constraint(equalTo: titleImage.centerYAnchor),

            divider.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: UIConstants.largePhotoDividerTopSpacing),
            divider.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            divider.heightAnchor.constraint(equalToConstant: UIConstants.largePhotoDividerHeight),
            
            imageView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: UIConstants.largePhotoImageViewTopSpacing),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.largePhotoImageViewLeadingSpacing),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.largePhotoImageViewTrailingSpacing),
            imageView.widthAnchor.constraint(equalToConstant: UIConstants.largePhotoImageViewSize),
            imageView.heightAnchor.constraint(equalToConstant: UIConstants.largePhotoImageViewSize)
        ])
    }
    
}
