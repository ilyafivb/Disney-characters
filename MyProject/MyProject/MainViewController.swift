import UIKit
import Stevia

class MainViewController: UIViewController {
    
    private var collectionView: UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }
    
    private var characters = [Character]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
    }
    
    private func fetch() {
        networkService.getCharacters(completion: { result in
            switch result {
            case .success(let characters):
                self.characters = characters
            case .failure(let error):
                print(error)
            }
        })
    }
    
    private func setupAll() {
        setupLayout()
        setupStyle()
    }
    
    private func setupStyle() {
        view.backgroundColor = .orange
    }
    
    private func setupLayout() {
        view.subviews {
            collectionView
        }
        
        collectionView.fillContainer(padding: 20)
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
}
