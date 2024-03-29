import UIKit
import Stevia
import SDWebImage
import CoreData

enum DetailVCListSections {
    case films([KinopoiskItemable])
    case shortFilms([KinopoiskItemable])
    case tvShows([KinopoiskItemable])
    
    var items: [KinopoiskItemable] {
        switch self {
        case .films(let items), .shortFilms(let items), .tvShows(let items):
            return items
        }
    }
    
    var counts: Int {
        return items.count
    }
    
    var title: String {
        switch self {
        case .films:
            return "Films"
        case .shortFilms:
            return "Short films"
        case .tvShows:
            return "TV Shows"
        }
    }
}

extension DetailVC {
    static func create(item: DisneyItemable, kinopoiskNetwork: KinopoiskNetworkable) -> DetailVC {
        return DetailVC(item: item, kinopoiskNetwork: kinopoiskNetwork)
    }
}

class DetailVC: UIViewController {
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DetailCollectionViewCell.self, forCellWithReuseIdentifier: DetailCollectionViewCell.id)
        collectionView.register(HeaderSypplementaryView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderSypplementaryView.id)
        collectionView.collectionViewLayout = setupCollectionLayout()
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private let avatarImageView = UIImageView()
    private let nameLabel = UILabel()
    private let backgroundNameView = UIView()
    private lazy var favouritesButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(image: isContains ? UIImage(systemName: "heart.fill") :UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(didTapFavouriteButton))
        barButton.tintColor = isContains ? .red : .gray
        return barButton
    }()
    
    private lazy var sections: [DetailVCListSections] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var films: DetailVCListSections = .films([]) {
        didSet {
            sections.append(films)
        }
    }
    private var shortsFilms: DetailVCListSections = .shortFilms([]) {
        didSet {
            sections.append(shortsFilms)
        }
    }
    private var tvShows: DetailVCListSections = .tvShows([]) {
        didSet {
            sections.append(tvShows)
        }
    }
    
    private let kinopoiskNetwork: KinopoiskNetworkable
    private let coreDataService = CoreDataService.shared
    var item: DisneyItemable
    private var isContains = false
    private var allFavouritesItems = [FavouritesItem]()
    
    private var normalImageWidth: CGFloat {
        view.bounds.size.width
    }
    private var smallImageSize: CGFloat = 100
    private var normalImageHeight: CGFloat {
        normalImageWidth + 50
    }
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAllFavouritesItems()
        setupAll()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    init(item: DisneyItemable, kinopoiskNetwork: KinopoiskNetworkable) {
        self.item = item
        self.kinopoiskNetwork = kinopoiskNetwork
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    
    private func setupAll() {
        fetch(namesItems: item.films ,list: films)
        fetch(namesItems: item.shortFilms ,list: shortsFilms)
        fetch(namesItems: item.tvShows ,list: tvShows)
        guard let imageUrl = item.imageUrl else { return }
        avatarImageView.sd_setImage(with: URL(string: imageUrl))
        
        setupStyle()
        setupLayout()
    }
    
    private func setupStyle() {
        view.backgroundColor = Palette.color(.lWhite_dDark)
        
        nameLabel.font = .systemFont(ofSize: 30)
        nameLabel.textAlignment = .left
        nameLabel.numberOfLines = 0
        nameLabel.textColor = Palette.color(.lDark_dWhite)
        nameLabel.text = item.name
        
        backgroundNameView.backgroundColor = .gray
        backgroundNameView.alpha = 0.7
        backgroundNameView.layer.cornerRadius = 20
        backgroundNameView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        avatarImageView.layer.cornerRadius = 20
        
        navigationItem.rightBarButtonItem = favouritesButton
    }
    
    private func setupLayout() {
        view.subviews {
            avatarImageView
            backgroundNameView
            nameLabel
            collectionView
        }
                
        avatarImageView.Top == 0
        avatarImageView.centerHorizontally()
        avatarImageView.Width == normalImageWidth
        avatarImageView.Height == normalImageHeight
        
        backgroundNameView.Bottom == avatarImageView.Bottom
        backgroundNameView.fillHorizontally()
        backgroundNameView.Height == nameLabel.Height

        nameLabel.Bottom == avatarImageView.Bottom
        nameLabel.fillHorizontally(padding: 20)
        
        collectionView.Top == avatarImageView.Bottom + 20
        collectionView.fillHorizontally()
        collectionView.Bottom == 0
    }
    
    private func setupCollectionLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.sections[sectionIndex]
            switch section {
            case .films:
                guard !section.items.isEmpty else { return nil }
                return self.setupSection()
            case .shortFilms:
                guard !section.items.isEmpty else { return nil }
                return self.setupSection()
            case .tvShows:
                guard !section.items.isEmpty else { return nil }
                return self.setupSection()
            }
        })
    }
    
    private func setupSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                            heightDimension: .fractionalHeight(1)))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .fractionalWidth(1)),
            repeatingSubitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(5)
        group.edgeSpacing = .init(leading: .fixed(5), top: .fixed(0), trailing: .fixed(5), bottom: .fixed(0))
        
        let supplementaryItems = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(40)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.boundarySupplementaryItems = [supplementaryItems]
        return section
    }
    
    //MARK: - Action
    
    private func fetch(namesItems: [String], list: DetailVCListSections) {
        let group = DispatchGroup()
        var newItems = [KinopoiskItemable]()
        namesItems.forEach { name in
            group.enter()
            kinopoiskNetwork.getSearchItems(name: name) { [weak self] result in
                switch result {
                case .success(let kinopoiskItems):
                    kinopoiskItems.forEach { kinopoiskItem in
                        guard kinopoiskItem.nameEn == name else { return }
                        group.enter()
                        self?.kinopoiskNetwork.getItem(id: kinopoiskItem.filmId, completion: { result in
                            switch result {
                            case .success(let item):
                                newItems.append(item)
                            case .failure(let error):
                                print(error)
                            }
                        group.leave()
                        })
                    }
                case .failure(let error):
                    print(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main, execute: {
            switch list {
            case .films:
                self.films = DetailVCListSections.films(newItems)
            case .shortFilms:
                self.shortsFilms = DetailVCListSections.shortFilms(newItems)
            case .tvShows:
                self.tvShows = DetailVCListSections.tvShows(newItems)
            }
        })
    }
    
    private func animateHeaderNormalSize() {
        UIView.animate(withDuration: 0.4, animations: {
            self.avatarImageView.heightConstraint?.constant = self.normalImageHeight
            self.avatarImageView.widthConstraint?.constant = self.normalImageWidth
            self.avatarImageView.topConstraint?.constant = 0
            self.avatarImageView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            self.avatarImageView.layer.cornerRadius = 25
            
            self.backgroundNameView.alpha = 0.7
            
            self.nameLabel.textAlignment = .left
            self.nameLabel.bottomConstraint?.constant = 0
            self.nameLabel.font = .systemFont(ofSize: 30)
            
            self.collectionView.topConstraint?.constant = 20
            self.view.layoutIfNeeded()
        })
    }
    
    private func animateHeaderSmallSize() {
        UIView.animate(withDuration: 0.4, animations: {
            self.avatarImageView.heightConstraint?.constant = self.smallImageSize
            self.avatarImageView.widthConstraint?.constant = self.smallImageSize
            self.avatarImageView.topConstraint?.constant = 100
            self.avatarImageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            self.avatarImageView.layer.cornerRadius = 50
            
            self.backgroundNameView.alpha = 0
            
            self.nameLabel.textAlignment = .center
            self.nameLabel.bottomConstraint?.constant = 30
            self.nameLabel.font = .systemFont(ofSize: 20)
            
            self.collectionView.topConstraint?.constant = 40
            self.view.layoutIfNeeded()
        })
    }
    
    private func fetchAllFavouritesItems() {
        allFavouritesItems = coreDataService.fetchFavouritesItems()
        
        if allFavouritesItems.count == 0 {
            isContains = false
        }
        
        allFavouritesItems.forEach { favouritesItem in
            if favouritesItem.name == item.name {
                isContains = true
                return
            } else {
                isContains = false
            }
        }
    }
    
    @objc private func didTapFavouriteButton() {
        if !isContains {
            favouritesButton.image = UIImage(systemName: "heart.fill")
            favouritesButton.tintColor = .red

            let dataImage = avatarImageView.image?.jpegData(compressionQuality: 1)
            let favouritesItem = FavouritesItem(context: coreDataService.context)
            favouritesItem.name = nameLabel.text
            favouritesItem.avatarImage = dataImage
            
            coreDataService.saveContext()
        } else {
            favouritesButton.image = UIImage(systemName: "heart")
            favouritesButton.tintColor = .gray
            
            allFavouritesItems.forEach { favouritesItem in
                if favouritesItem.name == item.name {
                    coreDataService.removeFavouritesItem(removeItem: favouritesItem)
                }
            }
        }
        fetchAllFavouritesItems()
    }
}

//MARK: - UICollectionView Delegate Methods

extension DetailVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sections[section].counts
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section] {
            case .films(let film):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.id, for: indexPath) as? DetailCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setup(item: film[indexPath.row])
                cell.shareCompletion = { items in
                    let shareVC = UIActivityViewController(activityItems: [items], applicationActivities: nil)
                    self.present(shareVC, animated: true)
                }
                return cell
            case .shortFilms(let shortFilm):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.id, for: indexPath) as? DetailCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setup(item: shortFilm[indexPath.row])
                cell.shareCompletion = { items in
                    let shareVC = UIActivityViewController(activityItems: [items], applicationActivities: nil)
                    self.present(shareVC, animated: true)
                }
                return cell
            case .tvShows(let tvShow):
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailCollectionViewCell.id, for: indexPath) as? DetailCollectionViewCell else {
                    return UICollectionViewCell()
                }
                cell.setup(item: tvShow[indexPath.row])
                cell.shareCompletion = { items in
                    let shareVC = UIActivityViewController(activityItems: [items], applicationActivities: nil)
                    self.present(shareVC, animated: true)
                }
                return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
            case UICollectionView.elementKindSectionHeader:
                let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderSypplementaryView.id, for: indexPath) as! HeaderSypplementaryView
                header.setup(headerName: sections[indexPath.section].title)
                return header
            default:
                return UICollectionReusableView()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            animateHeaderSmallSize()
        } else if scrollView.contentOffset.y < -30 {
            animateHeaderNormalSize()
        }
    }
}
