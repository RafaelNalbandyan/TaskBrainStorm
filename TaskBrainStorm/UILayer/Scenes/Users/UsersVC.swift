//
//  UsersVC.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import UIKit

final class UsersVC: UIViewController {
    
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Private properties
    
    private let viewModel = UsersVM()
    private var activityIndicatorView: UIActivityIndicatorView?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Users"
        self.navigationController?.isNavigationBarHidden = true
    }
    
    // MARK: - Private methods
    
    private func initialSetup() {
        bindViews()
        
        setupSegmentedControl()
        setupSearchBar()
        setupLoader()
        tableViewSetup()
        registerNotifications()
    }
    
    private func bindViews() {
        bindUsersData()
        bindLoading()
    }
    
    private func bindUsersData() {
        viewModel.usersDataCompilation = {
            self.tableView.reloadData()
        }
    }
    
    private func bindLoading() {
        viewModel.startLoading = {
            self.startLoading()
        }
        viewModel.stopLoading = {
            self.stopLoading()
        }
    }
    
    private func tableViewSetup() {
        self.tableView.register(UserTableViewCell.self)
    }
    
    private func setupSegmentedControl() {
        self.segmentedControl.selectedSegmentIndex = viewModel.selectedTab.rawValue
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search"
        hideKeyboardWhenTappedAround()
    }
    
    private func navigateToUserInfoScreen(viewModel: UserInfoVM) {
        let storyBoard = UIStoryboard(name: Constants.storyBoards.userInfo.rawValue,
                                      bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "UserInfoVC") as? UserInfoVC else {
            return
        }
        vc.viewModel = viewModel
        
        self.navigationController?.pushViewController(vc, animated: true) {
//            self.title = "Users"
        }
    }
    
    private func registerNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handledUpdateUsers(notification:)),
                                               name: .shouldUpdateUsers,
                                               object: nil)
        
    }
    
    @objc private func handledUpdateUsers(notification: Notification) {
        viewModel.updateLocalData = true
    }
    
    // MARK: - IBActions
    
    @IBAction private func segmentedControlChange(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 1 {
            viewModel.changeTabs(tab: .savedUsers)
        } else {
            viewModel.changeTabs(tab: .users)
        }
    }
    
    // MARK: - Activity indicator methods
    
    private func setupLoader() {
        activityIndicatorView = activityIndicator(frame: tableView.frame,
                                                  center: view.center)
        self.view.addSubview(activityIndicatorView!)
    }
    
    private func activityIndicator(style: UIActivityIndicatorView.Style = .large,
                                   frame: CGRect? = nil,
                                   center: CGPoint? = nil) -> UIActivityIndicatorView {
        
        let activityIndicatorView = UIActivityIndicatorView(style: style)
        
        if let frame = frame {
            activityIndicatorView.frame = frame
        }
        
        if let center = center {
            activityIndicatorView.center = center
        }
        
        return activityIndicatorView
    }
    
    private func startLoading() {
        activityIndicatorView?.startAnimating()
    }
    
    private func stopLoading() {
        self.activityIndicatorView?.stopAnimating()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

// MARK: - UITableViewDelegate, UITableViewDataSource methods

extension UsersVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.usersData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.reuseIdentifier, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        cell.model = viewModel.usersData[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user: UserProtocol = viewModel.usersData[indexPath.row]
        navigateToUserInfoScreen(viewModel: UserInfoVM(user: user))
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let users: [UserProtocol] = viewModel.usersData
        if indexPath.row == users.count - 6 {
            viewModel.fetchNextPage = true
        }
        cell.selectionStyle = .none
    }
}

extension UsersVC: UISearchBarDelegate {
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterUsers(key: searchText)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
