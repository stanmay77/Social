import UIKit
import MobileCoreServices


// Photo gallery VC

class PhotosVC: UIViewController {

    var userLogged: RegisteredUser
    var photosByUser: [String] = []
    
    lazy var photosCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionViewLayout.minimumInteritemSpacing = 20
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: PhotosCollectionViewCell.cellID)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    init(userLogged: RegisteredUser) {
        self.userLogged = userLogged
        super.init(nibName: nil, bundle: nil)
        photosByUser = userLogged.userPhotos
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        view.backgroundColor = .systemBackground
        navigationItem.title = NSLocalizedString("photosVCTitle", comment: "")
        let addPhotoBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo.badge.plus.fill"), style: .plain, target: self, action: #selector(tapAddPhoto))
        addPhotoBarButtonItem.tintColor = .monochrome
        navigationItem.rightBarButtonItem = addPhotoBarButtonItem
        
        view.addSubview(photosCollectionView)
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        
        NSLayoutConstraint.activate([
            photosCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            photosCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            photosCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: UIConstants.photosCollectionViewLeadingSpacing),
            photosCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: UIConstants.photosCollectionViewTrailingSpacing)
        ])
    }
    
    @objc func tapAddPhoto() {
        let imageMediaType = kUTTypeImage as String
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [imageMediaType]
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .fullScreen
        present(imagePicker, animated: true)
    }
    
    func updatePhotosGrid(with url: URL?) {
        CloudStorageManager.shared.uploadImageToCloud(for: url!, for: "", avatar: false) { [weak self] result in
            
            
            switch result {
            case .success(let url):
                
                guard let strongSelf = self else { return }
                strongSelf.userLogged.userPhotos.append(url.absoluteString)
                strongSelf.photosByUser.append(url.absoluteString)
                
                DispatchQueue.main.async {
                    strongSelf.photosCollectionView.reloadData()
                }

                StorageManager.shared.updateDocument(by: strongSelf.userLogged.login, fields: ["userPhotos": strongSelf.userLogged.userPhotos]) { (user: [RegisteredUser]) in
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }

}

extension PhotosVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosByUser.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotosCollectionViewCell.cellID, for: indexPath) as? PhotosCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureCell(for: photosByUser[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30 - 20) / 2
        let height = width
        return CGSize(width: Double(width), height: Double(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let largePhotoVC = LargePhotoVC()
        
        CloudStorageManager.shared.fetchCloudImage(for: URL(string: photosByUser[indexPath.row])!) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    largePhotoVC.imageToShow = image
                }
            case .failure(_):
                DispatchQueue.main.async {
                    largePhotoVC.imageToShow = UIImage(systemName: UIConstants.cloudUploadErrorImage)
                }
            }
        }
        
        self.present(largePhotoVC, animated: true)
        
    }
    
}

extension PhotosVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
        updatePhotosGrid(with: imageURL)
        //self.postImageURL = imageURL
        picker.dismiss(animated: true)
        }
    }
