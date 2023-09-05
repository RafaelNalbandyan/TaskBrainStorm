//
//  UserInfoVM.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation

final class UserInfoVM {
    
    public var user: UserProtocol
    public var isUserSaved: Bool
    
    private let usersLocalDBManager = LocalUsersService(localStorage: .coreData)
    
    
    init(user: UserProtocol) {
        self.user = user
        isUserSaved = false
        
        self.getUsersFromLocalDB()
    }
    
    public func saveToLocalDB() {
        
        guard let id = user.getId() else {
            return
        }
        let address = user.getAddress()
        let country = user.getCountry()
        let firsName = user.getFirstName()
        let lastName = user.getLastName()
        let info = user.getInfo()
        let imageUrl = user.getImageUrl()
        let latitude = user.getLatitude()
        let longitude = user.getLongitude()
        
        let localUserData = LocalUserData(id: id,
                                          address: address,
                                          country: country,
                                          firsName: firsName,
                                          info: info,
                                          lastName: lastName,
                                          imageUrl: imageUrl,
                                          latitude: latitude,
                                          longitude: longitude)
        
        let success = usersLocalDBManager.addUser(localUserData)
        isUserSaved = !isUserSaved
        
        postUpdateNotification()
    }
    
    public func removeFromLocalDB() {
        guard let id = self.user.getId() else {
            return
        }
        let success = usersLocalDBManager.removeUser(id: id)
        isUserSaved = !isUserSaved
        postUpdateNotification()
    }
    
    private func getUsersFromLocalDB() {
        guard let id = self.user.getId() else {
            isUserSaved = false
            return
        }
        guard let user = usersLocalDBManager.getUserById(id) else {
            isUserSaved = false
            return
        }
        isUserSaved = true
    }
    
    private func postUpdateNotification() {
        NotificationCenter.default.post(name: .shouldUpdateUsers,
                                        object: nil,
                                        userInfo: [:])
    }
}
