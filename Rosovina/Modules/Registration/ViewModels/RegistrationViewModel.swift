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
    
    @Published var firstNameValidationState: ValidationState = .idle
    
    @Published var lastNameValidationState: ValidationState = .idle
    
    @Published var phoneValidationState: ValidationState = .idle
    
    @Published var passwordValidationState: ValidationState = .idle
    
    @Published var emailValidationState: ValidationState = .idle
                
    @Published var firstNameText = ""
    
    @Published var lastNameText = ""
    
    @Published var phoneCode = "+966"
    
    @Published var phoneText = ""
        
    @Published var emailText = ""
    
    @Published var passwordText = ""
    
    @Published var passwordEyeOn = true
                    
    @Published var otpSentStatus: PhoneStatus = .idle
                    
    @Published var isAnimating = false
        
    //---------------------
        
    let dataService: RegistrationService
    
    init(dataService: RegistrationService = AppRegistrationService()) {
        self.dataService = dataService
    }
    
    func checkForPhone(phone: String, code: String) -> String{
        let fCode = code.replacingOccurrences(of: "+", with: "")
        if !phone.starts(with: "0"){
            return fCode + phone
        }else{
            return fCode + phone.dropFirst()
        }
    }
    
    func sendOTP() {
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
    }
      
    func switchPasswordEye(){
        self.passwordEyeOn.toggle()
    }
}

enum PhoneStatus: Identifiable {
    case idle, failed, success, error
    var id: Int {
        self.hashValue
    }
}
