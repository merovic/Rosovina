//
//  NotificationsService.swift
//  Rosovina
//
//  Created by Amir Ahmed on 17/01/2024.
//

import Foundation
import Combine
import Alamofire

protocol NotificationsService {
    func getNotifications(deviceToken: String) -> AnyPublisher<BaseResponseAnother<NotificationsAPIResponse>, AFError>
}

class AppNotificationsService: NotificationsService {
    func getNotifications(deviceToken: String) -> AnyPublisher<BaseResponseAnother<NotificationsAPIResponse>, Alamofire.AFError> {
        return APIClient.performDecodableRequest(route: APIRouter.notifications(deviceToken: deviceToken))
    }
}




