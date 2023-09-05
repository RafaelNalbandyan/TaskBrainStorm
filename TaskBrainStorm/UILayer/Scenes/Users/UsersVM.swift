//
//  UsersVM.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation
import CoreData

enum UserScreenTabs: Int {
    case users = 0
    case savedUsers = 1
}

final class UsersVM {
    
    // MARK: - Public properties
    
    public var usersData: [UserProtocol] = []
    public var selectedTab: UserScreenTabs = .users
    public var usersDataCompilation: (() -> Void)?
    public var startLoading: (() -> Void)?
    public var stopLoading: (() -> Void)?
    
    public var fetchNextPage: Bool = false {
        willSet {
            guard fetchNextPage else { return }
            startLoading?()
        }
        didSet {
            guard fetchNextPage else { return }
            fetchNext()
            stopLoading?()
        }
    }
    
    public var updateLocalData: Bool = false {
        didSet {
            guard updateLocalData else { return }
            getSavedUsersList()
            setupData()
            self.usersDataCompilation?()
        }
    }
    
    // MARK: - Private properties
    
    private var users: [UserProtocol] = []
    private var savedUsers: [UserProtocol] = []
    private var filtered: [UserProtocol] = []
    
    private var requestTimer: Timer?
    private let usersApi: UsersAPIProtocol = UsersAPI()
    private var page: Int = 1
    private let itemsCount: Int = 20
    private let usersLocalDBManager = LocalUsersService(localStorage: .coreData)

    init() {
        getUsers(page: page, itemsCount: itemsCount)
        getSavedUsersList()
    }
    
    // MARK: - Private properties
    
    private func getUsers(page: Int, itemsCount: Int) {
        usersApi.getUsers(page: page, itemsCount: itemsCount) {[unowned self] result in
            switch result {
            case .success(let response):
                let users = response?.results ?? []
                users.forEach{self.users.append($0)}
                self.usersData = self.users
                self.usersDataCompilation?()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getUsersFromLocalDB() -> [UserProtocol] {
        let users = usersLocalDBManager.getUsers() ?? []
        return users
    }
    
    private func setupData() {
        switch self.selectedTab {
        case .users:
            usersData = users
        case .savedUsers:
            usersData = savedUsers
        }
    }
    
    private func getSavedUsersList() {
        self.savedUsers = getUsersFromLocalDB()
    }
    
    private func fetchNext() {
        page += 1
        getUsers(page: page, itemsCount: itemsCount)
    }
    
    // MARK: - Public methods
    
    public func changeTabs(tab: UserScreenTabs) {
        selectedTab = tab
        setupData()
        self.usersDataCompilation?()
    }
    
    public func filterUsers(key: String) {
        guard key.count > 0 else {
            setupData()
            usersDataCompilation?()
            return
        }
        requestTimer?.invalidate()
        self.startLoading?()
        requestTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { _ in
            let filteredData = self.usersData.filter({$0.getFirstName()?.contains(key) ?? false})
            self.usersData = filteredData
            self.usersDataCompilation?()
            self.stopLoading?()
        }
    }
}

