//
//  UsersEntityService.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation
import CoreData

public enum UsersEntityRaws: String {
    case id
    case address
    case country
    case firsName
    case info
    case lastName
    case imageUrl
    case latitude
    case longitude
}

final class UsersEntityService: CoreDataService, LocalUsersProtocol {
    
    private let entityName: CoreDataEntities = .usersEntity
    
    override init() {
        super.init()
    }
    
    // MARK: - Public methods
    
    public func getUsers() -> [UserProtocol]? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName.rawValue)
        let context = persistentContainer.viewContext
        
        do {
            let objects = try context.fetch(fetchRequest)
            var localUsers: [UserProtocol] = []
            print(objects)
            objects.forEach({ userObject in
                let user = self.convertToUserData(userObject: userObject)
                localUsers.append(user)
            })
            return localUsers
        } catch let error as NSError {
            debugPrint(error)
            return nil
        }
    }
    
    public func getUserById(_ id: String) -> UserProtocol? {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName.rawValue)
        let context = persistentContainer.viewContext
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.fetchLimit = 1
        do {
            let objects = try context.fetch(fetchRequest)
            guard let userObject = objects.first else {
                return nil
            }
            let user = self.convertToUserData(userObject: userObject)
            return user
        } catch {
            debugPrint("error")
            return nil
        }
    }
    
    public func removeUser(id: String) -> Bool {
        let  fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName.rawValue)
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do {
            guard let result = try context.fetch(fetchRequest) as? [NSManagedObject] else {
                return false
            }
            guard let objc = result.first else { return false }
            context.delete(objc)
            do {
                try context.save()
                debugPrint("Record deleted")
                return true
            } catch let error as NSError {
                debugPrint(error)
                return false
            }
        } catch let error as NSError {
            debugPrint(error)
            return false
        }
    }
    
    public func addUser(_ user: UserProtocol) -> Bool {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName.rawValue,
                                                      in: context) else {
            return false
        }
        let newUser = NSManagedObject(entity: entity, insertInto: context)
        guard let id = user.getId() else {
            return false
        }
        let firstName = user.getFirstName() ?? ""
        let lastName = user.getLastName() ?? ""
        let country = user.getCountry() ?? ""
        let address = user.getAddress()
        let info = user.getInfo()
        let imageUrl = user.getImageUrl()
        let latitude = user.getLatitude()
        let longitude = user.getLongitude()
        
        newUser.setValue(id, forKey: UsersEntityRaws.id.rawValue)
        newUser.setValue(firstName, forKey: UsersEntityRaws.firsName.rawValue)
        newUser.setValue(lastName, forKey: UsersEntityRaws.lastName.rawValue)
        newUser.setValue(address, forKey: UsersEntityRaws.address.rawValue)
        newUser.setValue(info, forKey: UsersEntityRaws.info.rawValue)
        newUser.setValue(imageUrl, forKey: UsersEntityRaws.imageUrl.rawValue)
        newUser.setValue(country, forKey: UsersEntityRaws.country.rawValue)
        newUser.setValue(latitude, forKey: UsersEntityRaws.latitude.rawValue)
        newUser.setValue(longitude, forKey: UsersEntityRaws.longitude.rawValue)
        
        do {
            try context.save()
            return true
        } catch {
            print("Error saving")
            return false
        }
    }
    
    private func convertToUserData(userObject: NSManagedObject) -> UserProtocol {
        let id = userObject.value(forKey: UsersEntityRaws.id.rawValue) as? String
        let info = userObject.value(forKey: UsersEntityRaws.info.rawValue) as? String
        let firsName = userObject.value(forKey: UsersEntityRaws.firsName.rawValue) as? String
        let lastName = userObject.value(forKey: UsersEntityRaws.lastName.rawValue) as? String
        let imageUrl = userObject.value(forKey: UsersEntityRaws.imageUrl.rawValue) as? String
        let country = userObject.value(forKey: UsersEntityRaws.country.rawValue) as? String
        let address = userObject.value(forKey: UsersEntityRaws.address.rawValue) as? String
        let latitude = userObject.value(forKey: UsersEntityRaws.latitude.rawValue) as? String
        let longitude = userObject.value(forKey: UsersEntityRaws.longitude.rawValue) as? String
        let user = LocalUserData(id: id ?? "",
                                 address: address ?? "",
                                 country: country ?? "",
                                 firsName: firsName ?? "",
                                 info: info ?? "",
                                 lastName: lastName ?? "",
                                 imageUrl: imageUrl ?? "",
                                 latitude: latitude ?? "",
                                 longitude: longitude ?? "")
        return user
    }
}
