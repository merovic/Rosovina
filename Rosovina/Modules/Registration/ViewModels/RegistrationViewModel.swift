//
//  RegistrationViewModel.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 16/07/2022.
//

import Foundation
import Combine
import Firebase
import SwiftUI

class RegistrationViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
            
    @Published var firstNameText = ""
    
    @Published var lastNameText = ""
    
    @Published var phoneText = ""
        
    @Published var emailText = ""
    
    @Published var passwordText = ""
                
    @Published var canContinue = false
    
    @Published var otpSentStatus: PhoneStatus = .idle
                
    @Published var isAnimating = false
        
    //---------------------
        
    let dataService: RegistrationService
    
    init(dataService: RegistrationService = AppRegistrationService()) {
        self.dataService = dataService
        
        Publishers.CombineLatest($firstNameText, $lastNameText)
            .map { fullNameText, emailText in
                return (!fullNameText.isEmpty && (emailText.isValidEmail() || emailText.isEmpty))
            }
            .assign(to: \.canContinue, on: self)
            .store(in: &cancellables)
        
        Publishers.CombineLatest3($phoneText, $emailText, $passwordText)
            .map { fullNameText, birthDateText, emailText in
                return (!fullNameText.isEmpty && !birthDateText.isEmpty && (emailText.isValidEmail() || emailText.isEmpty))
            }
            .assign(to: \.canContinue, on: self)
            .store(in: &cancellables)
    }
    
    func checkForPhone(phone: String) -> String{
        if !phone.starts(with: "0"){
            return "20" + phone
        }else{
            return "2" + phone
        }
    }
    
    func sendOTP() {
        dataService.otp_send(request: OTPSendAPIRequest(phone: checkForPhone(phone: phoneText)))
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
                    if response.success {
                        self.otpSentStatus = .success
                    }
                }
            )
            .store(in: &cancellables)
    }
      
}

enum PhoneStatus: Identifiable {
    case idle, failed, success, error
    var id: Int {
        self.hashValue
    }
}
