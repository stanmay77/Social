import UIKit

// Class to create a collection cell object for photo gallery

final class PhotosCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "PhotosCollectionViewCell"
    
    lazy var photoImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        image.layer.cornerRadius = UIConstants.photosCornerRadius
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(photoImageView)
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: UIConstants.photoWidth),
            photoImageView.heightAnchor.constraint(equalToConstant: UIConstants.photoHeight)
        ])
    }
    
    // Cell configuration method
    public func configureCell(for photoURL: String) {
        
        // Clearing image before loading due to async loading
        self.photoImageView.image = nil
        
        // Fetching cloud image logic - setting photo
        CloudStorageManager.shared.fetchCloudImage(for: URL(string: photoURL)!) { [self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                    self.contentView.layoutIfNeeded()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    // In case of failure - loading predefined system image
                    self.photoImageView.image = UIImage(systemName: UIConstants.cloudUploadErrorImage)
                }
            }
        }
        
    }
    
    
}
