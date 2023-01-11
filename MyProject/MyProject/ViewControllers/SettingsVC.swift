import UIKit
import Stevia

class SettingsVC: UIViewController {
    private let segmentControl = UISegmentedControl(items: ["Device", "Light", "Dark"])
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
    }
    
    //MARK: - Setup
    
    private func setupAll() {
        setupStyle()
        setupLayout()
    }
    
    private func setupStyle() {
        view.backgroundColor = Palette.color(.lWhite_dDark)
        
        segmentControl.backgroundColor = Palette.color(.lLightGray_dGray)
        segmentControl.selectedSegmentIndex = AppConfigurationService.shared.theme.rawValue
        segmentControl.addTarget(self, action: #selector(segmentControlChanged), for: .valueChanged)
    }
    
    private func setupLayout() {
        view.subviews {
            segmentControl
        }
        
        segmentControl.centerInContainer()
        segmentControl.fillHorizontally(padding: 20)
        segmentControl.Height == 40
    }
    
    //MARK: - Action
    
    @objc private func segmentControlChanged() {
        AppConfigurationService.shared.theme = Theme(rawValue: segmentControl.selectedSegmentIndex) ?? .device
        view.window?.overrideUserInterfaceStyle = AppConfigurationService.shared.theme.getTheme()
    }
}
