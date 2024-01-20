//
//  ProfileViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 18/01/2024.
//

import Foundation
import Combine
import Firebase

class ProfileViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var userImage = LoginDataService.shared.getImageURL()
    
    @Published var userID = LoginDataService.shared.getID()
    
    @Published var userName = LoginDataService.shared.getFullName()
    
    @Published var isLogout = false
        
    @Published var errorMessage = ""
            
    @Published var isAnimating = false
    
    //---------------------------------
    
    let dataService: ProfileService
            
    init(dataService: ProfileService = AppProfileService()) {
        self.dataService = dataService
    }
    
    func logout() {
        LoginDataService.shared.setLogout()
    }
}


