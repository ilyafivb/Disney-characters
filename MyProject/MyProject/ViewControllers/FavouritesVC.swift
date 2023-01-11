import UIKit
import CoreData

class FavouritesVC: UITableViewController {
    private var items = [FavouritesItem]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let coreDataService = CoreDataService()

    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavouritesItems()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.separatorStyle = .none
        tableView.register(FavouritesItemViewCell.self, forCellReuseIdentifier: FavouritesItemViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func fetchFavouritesItems() {
        do {
            items = try coreDataService.context.fetch(FavouritesItem.fetchRequest())
        } catch {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouritesItemViewCell.id, for: indexPath) as! FavouritesItemViewCell
        cell.setup(item: items[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completion in
            let removeItem = self.items[indexPath.row]
            self.coreDataService.context.delete(removeItem)
            self.coreDataService.saveContext()
            self.fetchFavouritesItems()
        }
        return UISwipeActionsConfiguration(actions: [action])        
    }
}
