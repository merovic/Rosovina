//
//  SettingsViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 09/04/2024.
//

import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var languages: [RosovinaLanguage] = [RosovinaLanguage(name: "arabic".localized, code: "ar"), RosovinaLanguage(name: "english".localized, code: "en")]
    @Published var selectedLanguage: RosovinaLanguage = LoginDataService.shared.getAppLanguage()
                                                            
    //---------------------
            
}

