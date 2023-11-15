import MapKit


// Map Type selection cell

class MapTypeCollectionViewCell: UICollectionViewCell {
    
    static let cellID = "mapTypeCell"

    let mapTypeImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = UIConstants.universalCornerRadius
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let mapTypeLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .monochrome
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    func configureCell(for mapType: MKMapType) {
        
        self.contentView.addSubview(mapTypeImageView)
        self.contentView.addSubview(mapTypeLabel)
        
        self.layer.borderColor = UIColor.monochrome.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 8
        
        NSLayoutConstraint.activate([
            mapTypeImageView.topAnchor.constraint(equalTo: topAnchor, constant: UIConstants.mapTypeImageTopSpacing),
            mapTypeImageView.heightAnchor.constraint(equalToConstant: UIConstants.mapTypeImageHeight),
            mapTypeImageView.widthAnchor.constraint(equalToConstant: UIConstants.mapTypeImageWidth),
            mapTypeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            mapTypeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            mapTypeLabel.topAnchor.constraint(equalTo: mapTypeImageView.bottomAnchor, constant: UIConstants.mapTypeLabelTopSpacing),
            mapTypeLabel.heightAnchor.constraint(equalToConstant: UIConstants.mapTypeLabelHeight),
            mapTypeLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
           
        ])
        
        switch mapType {
        case .standard:
            mapTypeImageView.image = UIImage(named: "standard")
            mapTypeLabel.text = NSLocalizedString("standardMapType", comment: "")
        case .satellite:
            mapTypeImageView.image = UIImage(named: "satellite")
            mapTypeLabel.text = NSLocalizedString("satelliteMapType", comment: "")
        default:
            mapTypeImageView.image = UIImage(named: "standard")
            mapTypeLabel.text = ""
            
        }
        
    }
}

