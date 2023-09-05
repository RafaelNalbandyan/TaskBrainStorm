//
//  LocalUserData.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation

final class LocalUserData: UserProtocol {
    func getLongitude() -> String? {
        self.longitude
    }
    
    func getLatitude() -> String? {
        self.latitude
    }
    
    func getId() -> String? {
        return self.id
    }
    
    func getFirstName() -> String? {
        return self.firsName
    }
    
    func getLastName() -> String? {
        return self.lastName
    }
    
    func getInfo() -> String? {
        return self.info
    }
    
    func getAddress() -> String? {
        return self.address
    }
    
    func getCountry() -> String? {
        return self.country
    }
    
    func getImageUrl() -> String? {
        return self.imageUrl
    }
    
    let id: String
    let address: String?
    let country: String?
    let firsName: String?
    let info: String?
    let lastName: String?
    let imageUrl: String?
    let latitude: String?
    let longitude: String?
    
    init(id: String,
         address: String?,
         country: String?,
         firsName: String?,
         info: String?,
         lastName: String?,
         imageUrl: String?,
         latitude: String?,
         longitude: String?) {
        
        self.id = id
        self.address = address
        self.country = country
        self.firsName = firsName
        self.info = info
        self.lastName = lastName
        self.imageUrl = imageUrl
        self.latitude = latitude
        self.longitude = longitude
    }
}
