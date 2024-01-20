//
//  LoginViewModel.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 16/07/2022.
//

import Foundation
import Combine
import Firebase

class LoginViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    //var token = LoginDataService.shared.getFirebaseToken()
    var token = "asjdfbajhbsfabsjfhbajsb"
    
    @Published var loginStatus: LoginStatus = .idle
    
    @Published var phoneText = ""
    
    @Published var passwordText = ""
    
    @Published var passwordEyeOn = true
    
    @Published var canLogin = false
                
    @Published var isAnimating = false
        
    //---------------------
        
    let dataService: LoginService
    
    init(dataService: LoginService = AppLoginService()) {
        self.dataService = dataService
                
        Publishers.CombineLatest($passwordText, $phoneText)
            .map { passwordText, phoneText in
                return (!passwordText.isEmpty && !phoneText.isEmpty && phoneText.isValidPhone())
            }
            .assign(to: \.canLogin, on: self)
            .store(in: &cancellables)
    }
    
    func checkForPhone(phone: String) -> String{
        if !phone.starts(with: "0"){
            return "20" + phone
        }else{
            return "2" + phone
        }
    }
    
    func login() {
        
        self.isAnimating = true

        dataService.login(request: LoginAPIRequest(phone: checkForPhone(phone: phoneText), password: passwordText, mobileToken: "token"))
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
        
}

enum LoginStatus: Identifiable {
    case idle, failed, success, error
    var id: Int {
        self.hashValue
    }
}



