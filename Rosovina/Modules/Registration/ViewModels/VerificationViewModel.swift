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
    var token = "asjdfbajhbsfabsjfhbajsbjhgjgjhhgjhg"
    
    var phoneCode:String = ""
    var phoneText:String = ""
    var nameText:String = ""
    var emailText:String = ""
    var passwordText:String = ""
    
    var isResetPassword:Bool = false
    var isResetByEmail:Bool?
    var tokenResponse: GenerateTokenAPIResponse?
        
    @Published var codeText = ""
    
    @Published var registrationStatus: PhoneStatus = .idle
    
    @Published var forgetPasswordStatus: PhoneStatus = .idle
        
    @Published var errorMessage =  ""
                
    @Published var isAnimating = false
        
    //---------------------
    
    let dataService: RegistrationService
    
    init(phoneText:String, phoneCode:String, nameText:String? = nil, emailText:String? = nil, passwordText:String? = nil, isResetPassword:Bool = false, isResetByEmail:Bool? = nil, tokenResponse: GenerateTokenAPIResponse? = nil, dataService: RegistrationService = AppRegistrationService()) {
        self.phoneCode = phoneCode
        self.phoneText = phoneText
        self.nameText = nameText ?? ""
        self.emailText = emailText ?? ""
        self.passwordText = passwordText ?? ""
        
        self.isResetPassword = isResetPassword
        self.isResetByEmail = isResetByEmail
        self.tokenResponse = tokenResponse
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
    
    func emailOTPCheck() {
        if String(tokenResponse!.code) == codeText {
            self.forgetPasswordStatus = .success
        }else{
            self.errorMessage = "otp_not_match".localized
            self.forgetPasswordStatus = .failed
        }
    }
    
    func otpCheck() {
             
        if !codeText.isEmpty {
            self.isAnimating = true
            dataService.otp_check(request: OTPCheckAPIRequest(phone: checkForPhone(phone: phoneText, code: phoneCode), otp: codeText))
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
                            if self.isResetPassword {
                                self.forgetPasswordStatus = .success
                            }else{
                                self.register()
                            }
                        }else{
                            self.errorMessage = response.message
                            if self.isResetPassword {
                                self.forgetPasswordStatus = .failed
                            }else{
                                self.registrationStatus = .failed
                            }
                        }
                    }
                )
                .store(in: &cancellables)
        }else{
            self.errorMessage = "check_your_inputs_first".localized
            self.registrationStatus = .failed
        }
        
    }
    
    func retriveToken() {
        dataService.generateToken(request: PhoneAPIRequest(email: emailText))
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
                }
            )
            .store(in: &cancellables)
    }
    
    func register() {
                
        self.isAnimating = true
        
        dataService.register(request: RegistrationAPIRequest(name: nameText, countryCode: phoneCode, phone: checkForPhone(phone: phoneText, code: phoneCode), password: passwordText, email: emailText, mobileToken: token))
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

