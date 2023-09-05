//
//  UsersResponse.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation

final class UsersResponse: Codable {
    let results: [User]?
    let info: Info?
}
