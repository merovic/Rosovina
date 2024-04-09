//
//  RosovinaLanguage.swift
//  Rosovina
//
//  Created by Amir Ahmed on 09/04/2024.
//

import Foundation

// MARK: - RosovinaLanguage
struct RosovinaLanguage: Codable, Identifiable {
    var id = UUID().uuidString
    let name, code: String
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
}
