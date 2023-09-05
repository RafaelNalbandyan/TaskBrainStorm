//
//  User.swift
//  TaskBrainStorm
//
//  Created by Rafael Nalbandyan on 04.09.23.
//

import Foundation

protocol UserProtocol: AnyObject {
    func getId() -> String?
    func getFirstName() -> String?
    func getLastName() -> String?
    func getInfo() -> String?
    func getAddress() -> String?
    func getCountry() -> String?
    func getImageUrl() -> String?
    func getLongitude() -> String?
    func getLatitude() -> String?
}

class User: Codable, UserProtocol {
    func getLongitude() -> String? {
        self.location?.coordinates?.latitude
    }
    
    func getLatitude() -> String? {
        self.location?.coordinates?.longitude
    }
    
    func getFirstName() -> String? {
        return self.name?.first
    }
    
    func getLastName() -> String? {
        return self.name?.last
    }
    
    func getInfo() -> String? {
        let gender = self.gender?.rawValue
        let phone = self.phone
        let userInfo: [String?] = [gender, phone]
        return userInfo.compactMap({$0}).joined(separator: ", ")
    }
    
    func getAddress() -> String? {
        let city = self.location?.city
        let street = self.location?.street?.name
        let state = self.location?.state
        var data: [String?] = [ street, city, state]
        if let postcodeString = self.location?.postcode as? String {
            data.append(postcodeString)
        }
        if let postcodeInt = self.location?.postcode as? Int {
            data.append("\(postcodeInt)")
        }
        return data.compactMap({$0}).joined(separator: ", ")
    }
    
    func getCountry() -> String? {
        return self.location?.country
    }
    
    func getImageUrl() -> String? {
        return self.picture?.large
    }
    
    func getId() -> String? {
        return self.id?.value
    }
    
    let gender: Gender?
    let name: Name?
    let location: Location?
    let email: String?
    let login: Login?
    let dob, registered: Dob?
    let phone, cell: String?
    let id: ID?
    let picture: Picture?
    let nat: String?
}

// MARK: - Dob
struct Dob: Codable {
    let date: String?
    let age: Int?
}

enum Gender: String, Codable {
    case female = "female"
    case male = "male"
}

// MARK: - ID
struct ID: Codable {
    let name: String?
    let value: String?
}

// MARK: - Location
struct Location: Codable {
    let street: Street?
    let city, state, country: String?
    let postcode: AnyDataType?
    let coordinates: Coordinates?
    let timezone: Timezone?
}

// MARK: - Coordinates
struct Coordinates: Codable {
    let latitude, longitude: String?
}

// MARK: - Street
struct Street: Codable {
    let number: Int?
    let name: String?
}

// MARK: - Timezone
struct Timezone: Codable {
    let offset, description: String?
}

// MARK: - Login
struct Login: Codable {
    let uuid, username, password, salt: String?
    let md5, sha1, sha256: String?
}

// MARK: - Name
struct Name: Codable {
    let title: String?
    let first, last: String?
}

// MARK: - Picture
struct Picture: Codable {
    let large, medium, thumbnail: String?
}

enum AnyDataType: Codable {
    case int(Int)
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            self = try .int(container.decode(Int.self))
        } catch DecodingError.typeMismatch {
            do {
                self = try .string(container.decode(String.self))
            } catch DecodingError.typeMismatch {
                throw DecodingError.typeMismatch(AnyDataType.self,
                                                 DecodingError.Context(codingPath: decoder.codingPath,
                                                                       debugDescription: "Encoded payload not of an expected type"))
            }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let int):
            try container.encode(int)
        case .string(let string):
            try container.encode(string)
        }
    }
}
