import UIKit
import Stevia
import SDWebImage

class SearchItemViewCell: UITableViewCell {
    static let id = "SearchItemViewCell"
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
        layer.cornerRadius = 10
        
        nameLabel.font = .boldSystemFont(ofSize: 20)
        nameLabel.textColor = Palette.color(.lDark_dWhite)
        nameLabel.numberOfLines = 0
        
        avatarImageView.layer.cornerRadius = 10
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
    }
    
    private func setupLayout() {
        subviews {
            avatarImageView
            nameLabel
        }
        
        avatarImageView.centerVertically()
        avatarImageView.Leading == Leading
        avatarImageView.size(50)
        
        nameLabel.centerVertically()
        nameLabel.Leading == avatarImageView.Trailing + 10
        nameLabel.Trailing == Trailing - 10
    }
    
    func setup(item: DisneyItemable) {
        nameLabel.text = item.name
        guard let imageUrl = item.imageUrl else { return }
        avatarImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        avatarImageView.sd_setImage(with: URL(string: imageUrl))
    }
}
