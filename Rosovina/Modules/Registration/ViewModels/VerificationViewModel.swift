//
//  VerificationViewModel.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 16/07/2022.
//

import Foundation
import Combine
import Firebase
import SwiftUI

class VerificationViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    //var token = LoginDataService.shared.getFirebaseToken()
    var token = "asjdfbajhbsfabsjfhbajsb"
    
    var phoneText:String = ""
    var nameText:String = ""
    var emailText:String = ""
    var passwordText:String = ""
    
    var isResetPassword:Bool = false
        
    @Published var codeText = ""
    
    @Published var registrationStatus: PhoneStatus = .idle
    
    @Published var canVerify = false
    
    @Published var errorMessage =  ""
                
    @Published var isAnimating = false
        
    //---------------------
    
    let dataService: RegistrationService
    
    init(phoneText:String, nameText:String, emailText:String, passwordText:String, isResetPassword:Bool = false,dataService: RegistrationService = AppRegistrationService()) {
        self.phoneText = phoneText
        self.nameText = nameText
        self.emailText = emailText
        self.passwordText = passwordText
        
        self.isResetPassword = isResetPassword
        self.dataService = dataService
        
        $codeText
            .map { code in
                return !code.isEmpty
            }
            .assign(to: \.canVerify, on: self)
            .store(in: &cancellables)
    }
    
    func checkForPhone(phone: String) -> String{
        if !phone.starts(with: "0"){
            return "20" + phone
        }else{
            return "2" + phone
        }
    }
    
    
    func otpCheck() {
                
        self.isAnimating = true
        
        dataService.otp_check(request: OTPCheckAPIRequest(phone: checkForPhone(phone: phoneText), otp: codeText))
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
                        self.register()
                    }else{
                        self.errorMessage = response.message
                        self.registrationStatus = .failed
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func register() {
                
        self.isAnimating = true
        
        dataService.register(request: RegistrationAPIRequest(name: nameText, phone: checkForPhone(phone: phoneText), password: passwordText, email: emailText, mobileToken: token))
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
                        
                        LoginDataService.shared.setLogin()
                        
                        self.registrationStatus = .success
                    }else{
                        self.errorMessage = response.message
                        self.registrationStatus = .failed
                    }
                }
            )
            .store(in: &cancellables)
    }
    
}
