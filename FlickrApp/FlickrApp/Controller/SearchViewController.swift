import UIKit
import Foundation

class SearchViewController: UIViewController {
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "searchViewControllerTitleLabel"
        label.textAlignment = .center
        label.text = NSLocalizedString("Flickr Search", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    lazy private var mainTextLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.accessibilityIdentifier = "searchViewControllerMainTextLabel"
        label.textAlignment = .center
        label.text = NSLocalizedString("Photo Text", comment: "")
        return label
    }()
    
    lazy private var searchContentTextField: UITextField = {
        let textField = UITextField(frame: .zero)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.accessibilityIdentifier = "searchContentTextField"
        textField.placeholder = NSLocalizedString("Photos who's title, description or tags", comment: "")
        textField.clearButtonMode = .never
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.delegate = self
        textField.textAlignment = .center
        return textField
    }()
    
    lazy private var searchButton: UIButton = {
        let button = UIButton(type: .custom)
        let backButtonText = NSLocalizedString("Search", comment: "")
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        button.titleLabel?.font = UIFont.navigationBarTitle
        button.setTitle(backButtonText, for: .normal)
        button.accessibilityIdentifier = "searchViewControllerSearchButton"
        button.addTarget(self, action: #selector(SearchViewController.searchButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy private var historyButton: UIButton = {
        let button = UIButton(type: .custom)
        let backButtonText = NSLocalizedString("Search History", comment: "")
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        button.titleLabel?.font = UIFont.navigationBarTitle
        button.setTitle(backButtonText, for: .normal)
        button.accessibilityIdentifier = "searchViewControllerSearchHistoryButton"
        button.addTarget(self, action: #selector(SearchViewController.historyButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy private var localImagesButton: UIButton = {
        let button = UIButton(type: .custom)
        let backButtonText = NSLocalizedString("Viewd Images", comment: "")
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 30)
        button.titleLabel?.font = UIFont.navigationBarTitle
        button.setTitle(backButtonText, for: .normal)
        button.accessibilityIdentifier = "searchViewControllerLocalImagesButton"
        button.addTarget(self, action: #selector(SearchViewController.localImagesButtonPressed(_:)), for: .touchUpInside)
        return button
    }()
    
    private var customConstraints = [NSLayoutConstraint]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.accessibilityIdentifier = "searchViewController"
        view.addSubview(titleLabel)
        view.addSubview(mainTextLabel)
        view.addSubview(searchContentTextField)
        view.addSubview(searchButton)
        view.addSubview(historyButton)
        view.addSubview(localImagesButton)
    }
    
    private func searchButtonPressed(_ sender: UIButton) {
        startSearch()
    }
    
    private func historyButtonPressed(_ sender: UIButton) {
        
    }
    
    private func localImagesButtonPressed(_ sender: UIButton) {
        
    }
    
    private func startSearch() {
        guard let searchText = searchContentTextField.text else {
            // Tell user to enter something, or if by design, get all photos?
        }

        let resultViewController = SearchResultViewController(searchString: searchText)
        self.present(resultViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

