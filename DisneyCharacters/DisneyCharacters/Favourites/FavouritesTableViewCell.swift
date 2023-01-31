import UIKit
import Stevia
import SDWebImage

class FavouritesItemViewCell: UITableViewCell {
    static let id = "FavouritesItemViewCell"
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
        
        avatarImageView.Top == 10
        avatarImageView.Leading == Leading + 20
        avatarImageView.size(150)
        avatarImageView.Bottom == 10
        
        nameLabel.centerVertically()
        nameLabel.Leading == avatarImageView.Trailing + 10
        nameLabel.Trailing == Trailing - 10
    }
    
    func setup(item: FavouritesItem) {
        nameLabel.text = item.name
        guard let imageData = item.avatarImage else { return }
        avatarImageView.image = UIImage(data: imageData)
    }
}
