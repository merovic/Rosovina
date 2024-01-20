//
//  NotificationsAPIResponse.swift
//  Rosovina
//
//  Created by Amir Ahmed on 17/01/2024.
//

import Foundation

// MARK: - NotificationsAPIResponse
struct NotificationsAPIResponse: Codable {
    let data: [NotificationItem]
    let meta: Meta
}

extension NotificationsAPIResponse: Equatable {}

// MARK: - Datum
struct NotificationItem: Codable, Identifiable {
    let id: Int
    let type, title, body: String
    let isNew: Int
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, type, title, body
        case isNew = "is_new"
        case createdAt = "created_at"
    }
}

extension NotificationItem: Equatable {}
