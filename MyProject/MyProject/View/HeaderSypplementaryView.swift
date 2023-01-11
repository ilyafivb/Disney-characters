import UIKit
import Stevia

class HeaderSypplementaryView: UICollectionReusableView {
    static let id = "HeaderSypplementaryView"
    
    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Palette.color(.lLightGray_dGray)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    }
    
    private func setupLayout() {
        subviews {
            label
        }
        
        label.centerVertically()
        label.fillHorizontally(padding: 20)
    }
    
    func setup(headerName: String) {
        label.text = headerName
    }
}
