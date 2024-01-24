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
    
    @Published var phoneCode = "+20"
    
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
            .map { firstNameText, lastNameText in
                return (!firstNameText.isEmpty && !lastNameText.isEmpty)
            }
            .assign(to: \.canContinue, on: self)
            .store(in: &cancellables)
        
        Publishers.CombineLatest3($phoneText, $emailText, $passwordText)
            .map { phoneText, emailText, passwordText in
                return (phoneText.isValidPhone() && !passwordText.isEmpty && (emailText.isValidEmail() || !emailText.isEmpty))
            }
            .assign(to: \.canContinue, on: self)
            .store(in: &cancellables)
    }
    
    func checkForPhone(phone: String, code: String) -> String{
        let fCode = code.replacingOccurrences(of: "+", with: "")
        if !phone.starts(with: "0"){
            return fCode + phone
        }else{
            return fCode.dropLast() + phone
        }
    }
    
    func sendOTP() {
        if phoneText.isValidPhone() && !phoneText.isEmpty {
            dataService.otp_send(request: OTPSendAPIRequest(phone: checkForPhone(phone: phoneText, code: phoneCode)))
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
        }else{
            otpSentStatus = .error
        }
    }
      
}

enum PhoneStatus: Identifiable {
    case idle, failed, success, error
    var id: Int {
        self.hashValue
    }
}
