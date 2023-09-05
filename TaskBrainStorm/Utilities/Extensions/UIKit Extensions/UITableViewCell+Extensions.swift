//
//  UITableViewCell+Extensions.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import UIKit

extension UITableViewCell {
    
    static var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
    
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
