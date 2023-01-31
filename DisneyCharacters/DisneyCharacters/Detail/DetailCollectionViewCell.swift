import UIKit
import Stevia
import SDWebImage

class DetailCollectionViewCell: UICollectionViewCell {
    static let id = "DetailCollectionViewCell"
    private let avatarImageView = UIImageView()
    private let shareButton = UIButton()
    private let titleLabel = UILabel()
    private var kinopoiskUrl = ""
    
    var shareCompletion: (String) -> Void = { _ in }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    
    private func setupAll() {
        setupStyle()
        setupLayout()
    }
    
    private func setupStyle() {
        backgroundColor = Palette.color(.lWhite_dDark)
        layer.cornerRadius = 20
        
        titleLabel.font = .boldSystemFont(ofSize: 14)
        titleLabel.textColor = Palette.color(.lDark_dWhite)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.backgroundColor = .gray
        shareButton.tintColor = .blue
        shareButton.layer.cornerRadius = 10
        shareButton.alpha = 0.5
        shareButton.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        
        avatarImageView.layer.cornerRadius = 20
        avatarImageView.clipsToBounds = true
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatarImageView))
        avatarImageView.addGestureRecognizer(tap)
    }
    
    private func setupLayout() {
        subviews {
            avatarImageView
            shareButton
            titleLabel
        }
        
        avatarImageView.Top == 0
        avatarImageView.Leading == Leading
        avatarImageView.Trailing == Trailing
        
        shareButton.Trailing == avatarImageView.Trailing
        shareButton.Bottom == avatarImageView.Bottom
        shareButton.size(30)
        
        titleLabel.Top == avatarImageView.Bottom + 10
        titleLabel.fillHorizontally(padding: 20)
        titleLabel.Bottom == 0
    }
    
    func setup(item: KinopoiskItemable) {
        if let nameOriginal = item.nameOriginal {
            titleLabel.text = nameOriginal
        } else {
            titleLabel.text = item.nameEn
        }
        
        kinopoiskUrl = item.webUrl ?? ""
        guard let imageUrl = item.posterUrl else { return }
        avatarImageView.sd_setImage(with: URL(string: imageUrl))
    }
    
    //MARK: - Action
    
    @objc private func didTapAvatarImageView() {
        guard let webUrl = URL(string: kinopoiskUrl) else { return }
        UIApplication.shared.open(webUrl)
    }
    
    @objc private func didTapShareButton() {
        shareCompletion(kinopoiskUrl)
    }
}
