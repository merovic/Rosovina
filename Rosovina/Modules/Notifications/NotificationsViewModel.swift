//
//  NotificationsViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 17/01/2024.
//

import Foundation
import Combine
import Firebase

class NotificationsViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var notificationsList: [NotificationItem] = []
    
    let token = UIDevice.current.identifierForVendor!.uuidString
                                                
    @Published var isAnimating = false
                
    //---------------------
        
    let dataService: NotificationsService
    
    
    init(dataService: NotificationsService = AppNotificationsService()) {
        self.dataService = dataService
        getNotifications()
    }
        
    func getNotifications() {
        
        self.isAnimating = true
        
        dataService.getNotifications(deviceToken: token)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(_):
                        self.isAnimating = false
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                    self.notificationsList = response.data?.data ?? []
                }
            )
            .store(in: &cancellables)
    }
            
}



