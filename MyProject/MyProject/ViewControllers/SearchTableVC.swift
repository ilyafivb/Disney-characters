import UIKit
import Stevia

class SearchTableVC: UITableViewController {
    private var searchingItems = [DisneyItem]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
    }
    
    //MARK: - Setup
    
    private func setupAll() {
        setupStyle()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(SearchItemViewCell.self, forCellReuseIdentifier: SearchItemViewCell.id)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func setupStyle() {
        view.backgroundColor = Palette.color(.lWhite_dDark)
        tableView.separatorStyle = .none
    }
    
    //MARK: - Action
    
    func reloadItems(items: [DisneyItem]) {
        searchingItems = items
    }
    
    //MARK: - UITableViewDelegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchingItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchItemViewCell.id, for: indexPath) as! SearchItemViewCell
        cell.setup(item: searchingItems[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(60)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailVC(item: searchingItems[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

