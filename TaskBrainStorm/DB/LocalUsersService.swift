//
//  LocalUsersService.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation

class LocalUsersService: LocalUsersProtocol {
    private let manager: LocalUsersProtocol?
    
    let localStorage: LocalStorageType
    
    init(localStorage: LocalStorageType) {
        self.localStorage = localStorage
        if localStorage == .coreData {
            self.manager = UsersEntityService()
        } else {
            self.manager = nil // for example realm manager
        }
    }
    
    public func getUsers() -> [UserProtocol]? {
        guard let manager = manager else { return nil }
        return manager.getUsers()
    }
    
    public func getUserById(_ id: String) -> UserProtocol? {
        guard let manager = manager else { return nil }
        return manager.getUserById(id)
    }
    
    public func removeUser(id: String) -> Bool {
        guard let manager = manager else { return false }
        return manager.removeUser(id: id)
    }
    
    public func addUser(_ user: UserProtocol) -> Bool {
        guard let manager = manager else { return false }
        return manager.addUser(user)
    }
}
