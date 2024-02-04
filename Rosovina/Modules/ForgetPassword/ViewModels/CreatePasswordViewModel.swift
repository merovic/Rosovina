//
//  CreatePasswordViewModel.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 13/09/2022.
//

import Foundation
import Combine
import SwiftUI

class CreatePasswordViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    var phoneText = ""
    
    var token = ""
    
    @Published var passwordValidationState: ValidationState = .idle
    
    @Published var confirmValidationState: ValidationState = .idle
    
    @Published var resetStatus: ResetStatus = .idle
    
    @Published var loginStatus: LoginStatus = .idle
    
    @Published var passwordText = ""
    
    @Published var confirmText = ""
    
    @Published var passwordEyeOn = false
    
    @Published var confirmEyeOn = false
                    
    @Published var isAnimating = false
        
    //---------------------
        
    let dataService: ResetPasswordService
    
    init(phoneText:String, dataService: ResetPasswordService = AppResetPasswordService()) {
        self.phoneText = phoneText
        self.dataService = dataService
        
        retriveToken()
    
    }
    
    func retriveToken() {
                
        dataService.generateToken(phone: phoneText)
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
                    if response.success{
                        self.token = response.data?.token ?? ""
                    }else{
                        self.resetStatus = .failed
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func resetPassword() {
            
        self.isAnimating = true
        
        dataService.resetPassword(request: ResetPasswordAPIRequest(phone: self.phoneText, newPassword: passwordText), token: token)
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
                    if response.success{
                        self.resetStatus = .success
                    }else{
                        self.resetStatus = .failed
                    }
                }
            )
            .store(in: &cancellables)
        
    }
    
    func login() {
    
        AppLoginService().login(request: LoginAPIRequest(phone: phoneText, password: passwordText, mobileToken: token))
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
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            self.loginStatus = .success
                        }
                    }else{
                        self.loginStatus = .failed
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func switchPasswordEye(){
        self.passwordEyeOn.toggle()
    }
    
    func switchConfirmEye(){
        self.confirmEyeOn.toggle()
    }
        
}

enum ResetStatus: Identifiable {
    case idle, failed, success
    var id: Int {
        self.hashValue
    }
}



