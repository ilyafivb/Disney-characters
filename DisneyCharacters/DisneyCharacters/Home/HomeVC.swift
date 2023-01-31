import UIKit
import Stevia

extension HomeVC {
    static func create(networkService: DisneyNetworkable) -> HomeVC {
        return HomeVC(networkService: networkService)
    }
}

class HomeVC: UIViewController {
    private let searchBar = UISearchBar()
    private let searchContainerView = UIView()
    private let searchTableVC = SearchTableVC(style: .plain)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private var items = [DisneyItemable]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var searchItems = [DisneyItemable]() {
        didSet {
            searchTableVC.reloadItems(items: searchItems)
        }
    }
    
    private var networkService: DisneyNetworkable
    
    init(networkService: DisneyNetworkable) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        setupAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: - Setup
    
    private func setupAll() {
        setupLayout()
        setupStyle()
        setupSearchTableVC()
    }
    
    private func setupStyle() {
        view.backgroundColor = Palette.color(.lWhite_dDark)
        
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.id)
        collectionView.register(ActivityIndicatorCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ActivityIndicatorCollectionView.id)
        
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        
        searchContainerView.isHidden = true
    }
    
    private func setupLayout() {
        view.subviews {
            searchBar
            collectionView
            searchContainerView
        }
        
        searchBar.Top == view.safeAreaLayoutGuide.Top
        searchBar.fillHorizontally()
        
        collectionView.Top == searchBar.Bottom + 10
        collectionView.fillHorizontally(padding: 20)
        collectionView.Bottom == 0
        
        searchContainerView.Top == collectionView.Top
        searchContainerView.fillHorizontally(padding: 20)
        searchContainerView.Bottom == 0
    }
    
    private func setupSearchTableVC() {
        addChild(searchTableVC)
        searchContainerView.addSubview(searchTableVC.view)
        searchTableVC.view.fillContainer()
    }
    
    //MARK: - Action
    
    private func fetch() {
        networkService.getItems(completion: { [weak self] result in
            switch result {
            case .success(let items):
                self?.items += items
            case .failure(let error):
                self?.errorAlert(message: error.localizedDescription)
            }
        })
    }
    
    private func errorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let refreshAction = UIAlertAction(title: "Refresh", style: .cancel) { [weak self] _ in
            self?.fetch()
        }
        alert.addAction(refreshAction)
        present(alert, animated: true)
    }
    
    @objc private func getSearchItems() {
        guard let searchText = searchBar.searchTextField.text, !searchText.isEmpty else {
            searchItems = []
            return
        }
        
        networkService.getSearchItems(name: searchText, completion: { [weak self] result in
            switch result {
            case .success(let items):
                self?.searchItems = items
            case .failure(let error):
                print(error)
            }
        })
    }
}

//MARK: - UICollectionViewDelegate

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.id, for: indexPath) as! HomeCollectionViewCell
        cell.setup(item: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: networkService.isPaginating ? 50 : 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ActivityIndicatorCollectionView.id, for: indexPath)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let kinopoiskNetwork = KinopoiskNetwork()
        let detailVC = DetailVC.create(item: item, kinopoiskNetwork: kinopoiskNetwork)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension HomeVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        getSearchItems()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = ""
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchContainerView.isHidden = true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchItems = []
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchContainerView.isHidden = false
        searchBar.showsCancelButton = true
    }
}

//MARK: - UISearchBarDelegate

extension HomeVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        if position > (collectionView.contentSize.height - 100 - scrollView.frame.size.height) {
            guard !networkService.isPaginating else { return }
            fetch()
        }
    }
}
