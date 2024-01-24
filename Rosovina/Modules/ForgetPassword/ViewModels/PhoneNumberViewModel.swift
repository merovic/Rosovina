//
//  ForgetPasswordViewModel.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 13/09/2022.
//

import Foundation
import Combine
import Firebase
import SwiftUI

class PhoneNumberViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
            
    @Published var backPressed = false
    
    @Published var phoneCode = "+20"
    
    @Published var phoneText: String = ""
    
    @Published var checkedStatus: PhoneStatus = .idle
    
    @Published var otpSentStatus: PhoneStatus = .idle
    
    @Published var canCheck = false
    
    @Published var isAnimating = false
        
    //---------------------
        
    let dataService: ResetPasswordService
    
    init(dataService: ResetPasswordService = AppResetPasswordService()) {
        self.dataService = dataService
        
        $phoneText
            .map { phone in
                return !phone.isEmpty && phone.isValidPhone()
            }
            .assign(to: \.canCheck, on: self)
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
    
    func checkPhone() {
                
        if canCheck {
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
                        self.isAnimating = false
                        if response.success{
                            self.checkedStatus = .failed
                        }else{
                            self.checkedStatus = .success
                            self.sendOTP()
                        }
                    }
                )
                .store(in: &cancellables)
        }else{
            self.checkedStatus = .error
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
                    if response.message == "success"{
                        self.otpSentStatus = .success
                    }else{
                        self.otpSentStatus = .failed
                    }
                }
            )
            .store(in: &cancellables)
    }
}


