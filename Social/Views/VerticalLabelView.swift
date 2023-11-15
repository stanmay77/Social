import UIKit

// Base class to visualize vertical labels for subscriptions, posts and followers in ProfileHeaderView

final class VerticalLabelView: UIView {
    
    var number: Int {
        didSet {
            updateNumberLabel(for: number)
        }
    }
    var baseLabel: String
    
    lazy var baseTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: UIConstants.profileStatsLabelFont)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(frame: CGRect, number: Int, baseLabel: String) {
        self.number = number
        self.baseLabel = baseLabel
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(baseTextLabel)
        updateNumberLabel(for: number)
        NSLayoutConstraint.activate([
            baseTextLabel.topAnchor.constraint(equalTo: topAnchor),
            baseTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            baseTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            baseTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func updateNumberLabel(for number: Int) {
        let numberForLabel = number >= 1000 ? number/1000 : number
        let unitsLabel = number >= 1000 ? " thds" : ""
        baseTextLabel.text = "\(String(numberForLabel))\(unitsLabel)\n\(baseLabel)"
    }
}
