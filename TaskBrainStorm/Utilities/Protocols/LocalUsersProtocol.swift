//
//  LocalUsersProtocol.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation

protocol LocalUsersProtocol: AnyObject {
    func getUsers() -> [UserProtocol]?
    func getUserById(_ id: String) -> UserProtocol?
    func removeUser(id: String) -> Bool
    func addUser(_ user: UserProtocol) -> Bool
}
