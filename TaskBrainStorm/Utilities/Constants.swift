//
//  Constants.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation
import UIKit

struct Constants {
    static let baseURL: String = "https://randomuser.me/api"
    
    enum ButtonsGradientColor: String {
        case grayLinerFirst = "grayLinerFirst"
        case grayLinerLast = "grayLinerLast"
        case greenLinerFirst = "greenLinerFirst"
        case greenLinerLast = "greenLinerLast"
    }
    
    enum storyBoards: String {
        case main = "Main"
        case userInfo = "UserInfo"
    }
}
