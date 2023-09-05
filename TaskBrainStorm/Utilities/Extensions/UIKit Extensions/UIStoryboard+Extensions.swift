//
//  UIStoryboard+Extensions.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation
import UIKit

extension UIStoryboard {
    /// Creates a view controller from a supplied type and optional identifier.
    ///
    /// If no identifier is supplied the class name is used. This allows you to just name your view controllers
    /// with their class name.
    /// - Returns: A `UIViewController` instance of the specified type.
    func instantiateViewController<T>(ofType type: T.Type, withIdentifier identifier: String? = nil) -> T {
        let identifier = identifier ?? String(describing: type)
        guard let viewController = instantiateViewController(withIdentifier: identifier) as? T else {
            preconditionFailure("Expected view controller with identifier \(identifier) to be of type \(type)")
        }
        return viewController
    }
    
    /// Creates an initial view controller of the supplied type.
    /// - Returns: A `UIViewController` instance of the specified type.
    func instantiateInitialViewController<T>(ofType type: T.Type) -> T {
        guard let viewController = instantiateInitialViewController() as? T else {
            preconditionFailure("Expected initial view controller to be of type \(type)")
        }
        return viewController
    }
}
