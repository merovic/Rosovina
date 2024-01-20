//
//  MyProfileViewModel.swift
//  Rosovina
//
//  Created by Amir Ahmed on 18/01/2024.
//

import Foundation
import Combine
import Firebase

class MyProfileViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    @Published var userImage = LoginDataService.shared.getImageURL()
    
    @Published var userFirstName = String(LoginDataService.shared.getFullName().split(separator: " ")[0])
    
    @Published var userLastName = String(LoginDataService.shared.getFullName().split(separator: " ")[1])
        
    @Published var userEmail = LoginDataService.shared.getEmail()
    
    @Published var userAddresses: [UserAddress] = []
    
    @Published var selectedAddress: UserAddress?
    
    @Published var newImageData: Data = (UIImage(named: "user")?.jpeg(.lowest)!)!
    
    @Published var isLogout = false
    
    @Published var isProfileUpdated = false
    
    @Published var isAccountDeleted = false
    
    @Published var errorMessage = ""
            
    @Published var isAnimating = false
    
    //---------------------------------
    
    let dataService: ProfileService
    let addressDataService: AddressService
            
    init(dataService: ProfileService = AppProfileService(), addressDataService : AddressService = AppAddressService()) {
        self.dataService = dataService
        self.addressDataService = addressDataService
        self.load(url: URL(fileURLWithPath: LoginDataService.shared.getImageURL()))
        self.getAddresses()
    }
        
    func updateProfile() {
        
        self.isAnimating = true
                
        dataService.updateAccount(image: newImageData, name: userFirstName + " " + userLastName, email: userEmail)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(let error):
                        self.isAnimating = false
                        CustomPrint.swiftyAPIPrintError(message: error.localizedDescription)
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                    if response.success{
                        LoginDataService.shared.setFullName(name: response.data?.name ?? "")
                        LoginDataService.shared.setImageURL(url: response.data?.imageURL ?? "")
                        LoginDataService.shared.setEmail(email: response.data?.email ?? "")
                        self.isProfileUpdated = true
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func deleteAccount() {
        
        self.isAnimating = true
                
        dataService.deleteAccount()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        print("Publisher stopped observing")
                    case .failure(let error):
                        self.isAnimating = false
                        CustomPrint.swiftyAPIPrintError(message: error.localizedDescription)
                    }
                },
                receiveValue: { response in
                    self.isAnimating = false
                    if response.success{
                        self.isAccountDeleted = true
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func getAddresses() {
                
        addressDataService.getUserAddress()
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
                    self.userAddresses = response.data ?? []
                }
            )
            .store(in: &cancellables)
    }
    
    func load(url: URL) {
            DispatchQueue.global().async { [weak self] in
                if let data = try? Data(contentsOf: url) {
                    self?.newImageData = data
                }
            }
        }
                
}

