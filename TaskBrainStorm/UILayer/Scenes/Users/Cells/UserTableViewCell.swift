//
//  UserTableViewCell.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import UIKit
import Kingfisher
import CoreLocation

final class UserTableViewCell: UITableViewCell {

    @IBOutlet private weak var userImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var infoLabel: UILabel!
    @IBOutlet private weak var countryLabel: UILabel!
    @IBOutlet private weak var addressLabel: UILabel!
    
    public var model: UserProtocol? {
        didSet {
            guard let user = model else { return }
            initialSetup()
        }
    }
    
    private func initialSetup() {
        setupUserImageView()
        setupInfoLabel()
        setupNameLabel()
        setupAddressLabel()
        self.countryLabel.text = model?.getCountry()
    }
    
    private func setupUserImageView() {
        self.userImageView.image = UIImage()
        guard let urlString = model?.getImageUrl(),
              let url = URL(string: urlString) else { return }
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.kf.setImage(with: url,
                                  placeholder: nil,
                                  options: nil,
                                  completionHandler: nil)
    }
    
    private func setupNameLabel() {
        let firstName = model?.getFirstName() ?? ""
        let lastName = model?.getLastName() ?? ""
        nameLabel.text = "\(firstName) \(lastName)"
    }
    
    private func setupInfoLabel() {
        infoLabel.text = model?.getInfo()
        setupAddressLabel()
    }
    
    private func setupAddressLabel() {
        addressLabel.text = model?.getAddress()
    }
}
