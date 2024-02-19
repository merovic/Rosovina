//
//  GetProductsAPIRequest.swift
//  Rosovina
//
//  Created by Amir Ahmed on 03/01/2024.
//

import Foundation

// MARK: - GetProductsAPIRequest
struct GetProductsAPIRequest: Codable {
    let deviceToken: String
    let categories: [Int]?
    let keyword, sort: String?
    let cityID: Int
    let size: Int?
    let filter: Filter?
    let page: Int
    
    init(deviceToken: String, categories: [Int]? = nil, keyword: String? = nil, sort: String? = nil, size: Int? = nil, filter: Filter? = nil, page: Int) {
        self.deviceToken = deviceToken
        self.categories = categories
        self.keyword = keyword
        self.cityID = LoginDataService.shared.getUserCity().id
        self.sort = sort
        self.size = size
        self.filter = filter
        self.page = page
    }

    enum CodingKeys: String, CodingKey {
        case deviceToken = "device_token"
        case cityID = "city_id"
        case categories, keyword, sort, size, filter, page
    }
}

// MARK: - Filter
struct Filter: Codable {
    let occassions, price, brands, rating: [Int]?
    
    init(occassions: [Int]? = nil, price: [Int]? = nil, brands: [Int]? = nil, rating: [Int]? = nil) {
        self.occassions = occassions
        self.price = price
        self.brands = brands
        self.rating = rating
    }
}

