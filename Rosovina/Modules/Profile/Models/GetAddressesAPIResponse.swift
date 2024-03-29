//
//  GetAddressesAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 04/01/2024.
//

import Foundation

// MARK: - UserAddress
struct UserAddress: Codable, Identifiable {
    let id: Int?
    let name, address: String?
    let buildingNo: String
    let cityID, countryID: IntOrString
    let areaName, subAreaID, flatNo: String
    let isDefault: Bool
    let coordinates, notes: String
    let areaID: Int
    let receiverPhone, receiverName: String?
    let countryName: String
    let cityName, postalCode, subAreaName: String
    
    func cityIDString() -> String {
        return cityID.stringValue()
    }
    
    func countryIDString() -> String {
        return countryID.stringValue()
    }
    
    func cityIDInt() -> Int {
        return cityID.intValue() ?? 0
    }
    
    func countryIDInt() -> Int {
        return countryID.intValue() ?? 0
    }

    enum CodingKeys: String, CodingKey {
        case buildingNo = "building_no"
        case cityID = "city_id"
        case id
        case countryID = "country_id"
        case areaName = "area_name"
        case subAreaID = "sub_area_id"
        case flatNo = "flat_no"
        case isDefault = "is_default"
        case name, coordinates, notes
        case areaID = "area_id"
        case receiverPhone = "receiver_phone"
        case receiverName = "receiver_name"
        case countryName = "country_name"
        case address
        case cityName = "city_name"
        case postalCode = "postal_code"
        case subAreaName = "sub_area_name"
    }
}

extension UserAddress: Equatable {}

// MARK: - AddUserAddress
struct AddUserAddress: Codable {
    let name, address, coordinates: String
    let countryID: Int
    let cityID: Int
    let areaID: Int
    let receiverName: String
    let receiverPhone: String
    let floorNo, flatNo, postalCode, notes: String
    let isDefault: Bool
    
    enum CodingKeys: String, CodingKey {
        case name, address, coordinates
        case countryID = "country_id"
        case cityID = "city_id"
        case areaID = "area_id"
        case floorNo = "floor_no"
        case flatNo = "flat_no"
        case postalCode = "postal_code"
        case notes
        case isDefault = "is_default"
        case receiverPhone = "receiver_phone"
        case receiverName = "receiver_name"
    }
}

extension AddUserAddress: Equatable {}

typealias GetAddressesAPIResponse = [UserAddress]


enum IntOrString: Codable {
    case intVal(Int)
    case stringVal(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self = .intVal(intValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .stringVal(stringValue)
        } else {
            throw DecodingError.typeMismatch(IntOrString.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Int or String value expected."))
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .intVal(let intValue):
            try container.encode(intValue)
        case .stringVal(let stringValue):
            try container.encode(stringValue)
        }
    }
    
    func stringValue() -> String {
            switch self {
            case .intVal(let intValue):
                return "\(intValue)"
            case .stringVal(let stringValue):
                return stringValue
            }
        }
    
    func intValue() -> Int? {
        switch self {
        case .intVal(let intValue):
            return intValue
        case .stringVal(let stringValue):
            return Int(stringValue)
        }
    }
}

extension IntOrString: Equatable {}
