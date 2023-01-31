import UIKit
import Stevia
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {
    static let id = "HomeCollectionViewCell"
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let backgroundNameView = UIView()
    
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
        
        nameLabel.font = .boldSystemFont(ofSize: 30)
        nameLabel.textColor = Palette.color(.lDark_dWhite)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        
        backgroundNameView.backgroundColor = .gray
        backgroundNameView.alpha = 0.7
        backgroundNameView.layer.cornerRadius = 20
        backgroundNameView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
    }
    
    private func setupLayout() {
        subviews {
            avatarImageView
            backgroundNameView
            nameLabel
        }
        
        avatarImageView.Top == 0
        avatarImageView.fillHorizontally()
        avatarImageView.Bottom == 0
        
        backgroundNameView.Bottom == avatarImageView.Bottom
        backgroundNameView.fillHorizontally()
        backgroundNameView.Height == nameLabel.Height
        
        nameLabel.fillHorizontally(padding: 20)
        nameLabel.Bottom == backgroundNameView.Bottom
    }
    
    func setup(item: DisneyItemable) {
        nameLabel.text = item.name
        guard let imageUrl = item.imageUrl else { return }
        avatarImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        avatarImageView.sd_setImage(with: URL(string: imageUrl))
    }
}
