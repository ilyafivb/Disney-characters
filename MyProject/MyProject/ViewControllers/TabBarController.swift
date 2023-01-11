import UIKit

class TabBarController: UITabBarController {
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
    }
    
    //MARK: - Setup
    
    private func setupAll() {
        addVC()
        setupStyle()
    }
    
    private func setupStyle() {
        UITabBar.appearance().barTintColor = Palette.color(.lWhite_dDark)
        tabBar.tintColor = Palette.color(.lLightBlue_dBlue)
        tabBar.backgroundColor = Palette.color(.lWhite_dDark)
    }
    
    private func addVC() {
        viewControllers = [
            createViewControllers(vc: MainVC(), title: "Home", systemImage: "house.fill"),
            createViewControllers(vc: SettingsVC(), title: "Settings", systemImage: "gear"),
            createViewControllers(vc: FavouritesVC(), title: "Favourites", systemImage: "star")
        ]
    }
    
    private func createViewControllers(vc: UIViewController, title: String, systemImage: String) -> UIViewController {
        let navigationVC = UINavigationController(rootViewController: vc)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = UIImage(systemName: systemImage)
        return navigationVC
    }
}
