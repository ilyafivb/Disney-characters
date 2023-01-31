import UIKit
import Stevia

class ActivityIndicatorCollectionView: UICollectionReusableView {
    static let id = "ActivityIndicatorCollectionView"
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        subviews {
            activityIndicator
        }
        
        activityIndicator.centerInContainer()
    }
}

class ActivityIndicatorViewCell: UICollectionViewCell {
    static let id = "ActivityIndicatorViewCell"
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupLayout()
        activityIndicator.startAnimating()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        subviews {
            activityIndicator
        }
        
        activityIndicator.Top == 0
        activityIndicator.centerHorizontally()
        activityIndicator.Bottom == 0
    }
}
