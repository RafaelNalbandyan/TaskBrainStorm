//
//  UsersTarget.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation
import Alamofire

enum UsersTarget {
    case getUsers(page: Int, itemsCount: Int)
}

extension UsersTarget: TargetType {
    var baseURL: String {
        switch self {
        default:
            return Constants.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .getUsers:
            return ""
        }
    }
    
    var methods: HTTPMethod {
        switch self{
        case .getUsers:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getUsers(page: let page, itemsCount: let count):
            return .requestParameters(parameters: [
                "seed": "brainstorm",
                "results": count,
                "page": page], encoding: URLEncoding(destination: .queryString))
//            //            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        default:
            return[:]
        }
    }
}
