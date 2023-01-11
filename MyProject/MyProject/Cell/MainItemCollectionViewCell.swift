import UIKit
import Stevia
import SDWebImage

class MainItemCollectionViewCell: UICollectionViewCell {
    static let id = "MainItemCollectionViewCell"
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAll() {
        setupStyle()
        setupLayout()
    }
    
    private func setupStyle() {
        backgroundColor = Palette.color(.lWhite_dDark)
        layer.cornerRadius = 20
        
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textColor = Palette.color(.lDark_dWhite)
        nameLabel.numberOfLines = 0
        
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
    }
    
    private func setupLayout() {
        subviews {
            avatarImageView
            nameLabel
        }
        
        avatarImageView.centerVertically()
        avatarImageView.Leading == Leading
        avatarImageView.size(150)
        
        nameLabel.centerVertically()
        nameLabel.Leading == avatarImageView.Trailing + 10
        nameLabel.Trailing == Trailing - 10
    }
    
    func setup(item: DisneyItem) {
        nameLabel.text = item.name
        guard let imageUrl = item.imageUrl else { return }
        SDImageCache.shared.config.maxDiskSize = 1024 * 1024 * 300
        avatarImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        avatarImageView.sd_setImage(with: URL(string: imageUrl))
    }
}
