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
    
    func checkPhone() {
        
        self.isAnimating = true
        
        dataService.check_phone(request: PhoneAPIRequest(phone: checkForPhone(phone: phoneText, code: phoneCode)))
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
                    if !response.success {
                        self.otpSentStatus = .error
                        self.isAnimating = false
                    } else{
                        self.sendOTP()
                    }
                }
            )
            .store(in: &cancellables)
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
                    self.isAnimating = false
                    if response.success {
                        self.otpSentStatus = .success
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func register() {
        
        dataService.register(request: RegistrationAPIRequest(name: firstNameText + " " + lastNameText, countryCode: phoneCode, phone: phoneText, password: passwordText, email: emailText, mobileToken: ""))
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
                    if response.success {
                        LoginDataService.shared.setAuthToken(token: response.data!.token)
                        LoginDataService.shared.setID(id: (response.data?.userInfo.id)!)
                        LoginDataService.shared.setFullName(name: response.data?.userInfo.name ?? "")
                        LoginDataService.shared.setImageURL(url: response.data?.userInfo.imageURL ?? "")
                        LoginDataService.shared.setMobileNumber(number: response.data?.userInfo.phone ?? "")
                        LoginDataService.shared.setDateOfBirth(date: response.data?.userInfo.dateOfBirth ?? "")
                        LoginDataService.shared.setPassword(password: self.passwordText)
                        LoginDataService.shared.setEmail(email: response.data?.userInfo.email ?? "")
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            LoginDataService.shared.setLogin()
                        }
                        
                        self.otpSentStatus = .success
                    }else{
                        self.otpSentStatus = .error
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
