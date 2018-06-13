import UIKit

private let reuseIdentifier = "Cell"

class SearchResultViewController: UIViewController {
    
    // TODO Use collection view may be better than table view as it is used for displaying images
    
    let searchString: String
    private let imagesListCellReuseId = "imagesListCellReuseId"
    private var datasource: ImageListsDataSourceProtocol
    private var customConstraints = [NSLayoutConstraint]()
    
    lazy private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.accessibilityIdentifier = "imagesListTableView"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 120, bottom: 0, right: 0)
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: imagesListCellReuseId)
        return tableView
    }()
    
    lazy private var noItemsView: NoItemsView = {
        let view = NoItemsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    init(searchString: String) {
        self.searchString = searchString
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(noItemsView)
        addConstraints()
        
        let httpClient = HTTPClientFactory.makeClient()
        let searchClient = SearchClient(httpClient: httpClient)
        searchClient.fetchImageData(searchString: searchString)
        
        if datasource.hasMore {
            fetchMore()
        } else {
            configureNoItemsScreen()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func addConstraints() {
        guard customConstraints.isEmpty else { return }
        
        let views: [String: Any] = [
            "tableView": tableView
        ]
        
        let metrics = [
        ]
        
        NSLayoutConstraint.activate(customConstraints)
    }
    
    private func configureNoItemsScreen() {
        let count = datasource.fetchedObjectsCount
        noItemsView.isHidden = count != 0
        if count == 0 && datasource.isFetchingMore {
            noItemsView.showSpinnerAndHideItemText()
        } else {
            noItemsView.showItemTextAndHideSpinner()
        }
    }
    
    private func configureCell(_ cell: ImagesListCell, atIndexPath indexPath: IndexPath) {
        let fetchObject = datasource.fetchedObject(at: indexPath)
        
        if let image = fetchObject as? ImageFile {
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollOffset = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.frame.size.height
        let scrollContentSizeHeight = scrollView.contentSize.height
        
        if scrollOffset + scrollViewHeight > scrollContentSizeHeight - 100 {
            fetchMore()
        }
    }
    
    private func fetchMore() {
        guard (!datasource.isFetchingMore) && datasource.hasMore else { return }
        
        datasource.fetchMore(
            startHandler: { [weak self] objectType in
                guard let `self` = self else { return }
            }, completionHandler: { [weak self] success, objectType in
                guard let `self` = self else { return }
                
                self.tableView.reloadData()
                self.configureNoItemsScreen()
            }
        )
    }
    
}

extension SearchResultViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return ImagesListCell.defaultHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ImagesListCell.defaultHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard datasource.isFilesSection(indexPath.section) else { return nil }
        guard let fetchedObject = datasource.fetchedObject(at: indexPath) else { return nil }
        
        var editActions = [UITableViewRowAction]()
        
        return editActions
    }
    
}

extension SearchResultViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return datasource.sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.objectsCount(at: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: imagesListCellReuseId, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        
        configureCell(imageListCell, atIndexPath: indexPath)
        return cell
    }
    
}

extension SearchResultViewController: ImagesListDataSourceDelegate {
    
    func datasourceWillChangeContent(_ datasource: ImageListsDataSourceProtocol) {
        tableView.beginUpdates()
    }
    
    func datasource(_ datasource: ImageListsDataSourceProtocol, didInsert anObject: ImagesListObject, at indexPath: IndexPath) {
        tableView.insertRows(at: [indexPath], with: .fade)
    }
    
    func datasource(_ datasource: ImageListsDataSourceProtocol, didDelete anObject: ImagesListObject, at indexPath: IndexPath) {
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    func datasource(_ datasource: ImageListsDataSourceProtocol, didUpdate anObject: ImagesListObject, at indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
        configureCell(cell, atIndexPath: indexPath)
    }
    
    func datasourceDidChangeContent(_ controller: ImageListsDataSourceProtocol) {
        tableView.endUpdates()
        configureNoItemsScreen()
    }
    
}

extension SearchResultViewController: SearchClientImageDelegate {
    func searchClient(_ searchClient: AnySearchClient, didFetchImage image: UIImage?, atUrl url: String) {
        
    }
}

extension SearchResultViewController: SearchClientDataDelegate {
    func searchClient(_ searchClient: AnySearchClient, didFetchImageData imageData: [TransientImageFile]) {
        
    }
}
