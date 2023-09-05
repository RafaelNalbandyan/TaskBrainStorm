//
//  UsersAPI.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation

protocol UsersAPIProtocol: AnyObject {
    func getUsers(page: Int, itemsCount: Int, completion: @escaping (Result<UsersResponse?, NSError>) -> Void)
}

final class UsersAPI: BaseAPI<UsersTarget>,  UsersAPIProtocol {
    //MARK:- Requests
    
    func getUsers(page: Int, itemsCount: Int, completion: @escaping (Result<UsersResponse?, NSError>) -> Void) {
        fetchData(target: .getUsers(page: page, itemsCount: itemsCount), responseClass: UsersResponse.self) { (result) in
            completion(result)
        }
    }
}
