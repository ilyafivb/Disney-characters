import UIKit

class Palette {
    enum ColorKind: String {
        case lWhite_dDark
        case lDark_dWhite
        case lLightGray_dGray
        case lLightBlue_dBlue
        
        var color: UIColor {
            guard let color = UIColor(named: rawValue) else { return .clear }
            return color
        }
    }
    
    static func color(_ colorKind: ColorKind) -> UIColor {
        colorKind.color
    }
}
