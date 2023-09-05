//
//  UITableView+Extensions.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import UIKit

extension UITableView {
    func register<T: UITableViewCell>(_: T.Type) {
        let bundle = Bundle(for: T.self)
        
        let isIpad = UIDevice.current.userInterfaceIdiom == .pad
        var nibName = isIpad ? (T.nibName + "~iPad") : T.nibName
        if let _ = bundle.path(forResource: nibName, ofType: "nib") {
        } else {
            nibName = T.nibName
        }
        let nib = UINib.init(nibName: nibName, bundle: bundle)
        
        register(nib, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        return cell
    }
}
