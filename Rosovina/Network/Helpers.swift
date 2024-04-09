//
//  Helpers.swift
//  CombineNetworking
//
//  Created by Amir Ahmed on 11/12/2023.
//

import Foundation

enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
    case language = "lang"
}

enum ContentType: String {
    case json = "application/json"
}

enum RequestParameterMethod: String {
    case pathParam   = "pathParam"
    case queryParam  = "queryParam"
    case formParam   = "formParam"
}
