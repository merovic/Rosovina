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
    let coordinates: String
    let countryID: String
    let countryName: String
    let cityID: String
    let cityName: String
    let areaID: String
    let email, receiverPhone, receiverName, areaName, subAreaID, subAreaName, buildingNo: String
    let floorNo, flatNo, postalCode, notes: String?
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case id, name, address, coordinates
        case countryID = "country_id"
        case countryName = "country_name"
        case cityID = "city_id"
        case cityName = "city_name"
        case areaID = "area_id"
        case areaName = "area_name"
        case subAreaID = "sub_area_id"
        case subAreaName = "sub_area_name"
        case buildingNo = "building_no"
        case floorNo = "floor_no"
        case flatNo = "flat_no"
        case postalCode = "postal_code"
        case notes
        case email
        case receiverPhone = "receiver_phone"
        case receiverName = "receiver_name"
        case isDefault = "is_default"
    }
}

extension UserAddress: Equatable {}

// MARK: - AddUserAddress
struct AddUserAddress: Codable {
    let name, address, coordinates: String
    let countryID: Int
    let cityID: Int
    let areaID: Int
    let buildingNo: String
    let receiverName: String
    let receiverPhone: String
    let floorNo, flatNo, postalCode, notes: String
    let isDefault: Bool

    enum CodingKeys: String, CodingKey {
        case name, address, coordinates
        case countryID = "country_id"
        case cityID = "city_id"
        case areaID = "area_id"
        case buildingNo = "building_no"
        case receiverName = "receiver_name"
        case receiverPhone = "receiver_phone"
        case floorNo = "floor_no"
        case flatNo = "flat_no"
        case postalCode = "postal_code"
        case notes
        case isDefault = "is_default"
    }
}

extension AddUserAddress: Equatable {}

typealias GetAddressesAPIResponse = [UserAddress]

