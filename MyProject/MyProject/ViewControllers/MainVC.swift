import UIKit
import Stevia

class MainVC: UIViewController, UIScrollViewDelegate {
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
    
    private var items = [DisneyItem]() {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var searchItems = [DisneyItem]() {
        didSet {
            searchTableVC.reloadItems(items: searchItems)
        }
    }
    
    private let networkService = DisneyNetworkService()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        setupAll()
    }
    
    //MARK: - Setup
    
    private func setupAll() {
        setupLayout()
        setupStyle()
        setupSearchTableVC()
    }
    
    private func setupStyle() {
        view.backgroundColor = Palette.color(.lWhite_dDark)
        
        collectionView.register(MainItemCollectionViewCell.self, forCellWithReuseIdentifier: MainItemCollectionViewCell.id)
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
                print(error)
            }
        })
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

extension MainVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainItemCollectionViewCell.id, for: indexPath) as! MainItemCollectionViewCell
        cell.setup(item: items[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == items.count - 1 && items.count <= 500 {
            fetch()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ActivityIndicatorCollectionView.id, for: indexPath)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailVC(item: items[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - UISearchBarDelegate

extension MainVC: UISearchBarDelegate {
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
