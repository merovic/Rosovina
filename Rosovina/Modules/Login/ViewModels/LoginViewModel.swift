//
//  LoginViewModel.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 16/07/2022.
//

import Foundation
import Combine
import Firebase
import CoreTelephony

class LoginViewModel: ObservableObject {
    
    private var cancellables: Set<AnyCancellable> = []
    
    //---------------------
    
    //var token = LoginDataService.shared.getFirebaseToken()
    var token = "asjdfbajhbsfabsjfhbajsb"
    
    @Published var phoneValidationState: ValidationState = .idle
    
    @Published var emailValidationState: ValidationState = .idle
    
    @Published var passwordValidationState: ValidationState = .idle
    
    @Published var selectedType = 0
    
    @Published var loginStatus: LoginStatus = .idle
    
    @Published var phoneCode = "+966"
    
    @Published var phoneText = ""
    
    @Published var emailText = ""
    
    @Published var passwordText = ""
    
    @Published var passwordEyeOn = true
    
    @Published var canLogin = false
                
    @Published var isAnimating = false
        
    //---------------------
        
    let dataService: LoginService
    
    init(dataService: LoginService = AppLoginService()) {
        self.dataService = dataService
    }
    
    func checkForPhone(phone: String) -> String{
        let fCode = phoneCode.replacingOccurrences(of: "+", with: "")
        if !phone.starts(with: "0"){
            return fCode + phone
        }else{
            return fCode + phone.dropFirst()
        }
    }
    
    func getUserCountry() {
        let controller = CountryDectectorViewController()
        controller.loadViewIfNeeded()
        controller.didDetectCountryCode = { countryCode in
            print(countryCode ?? "")
        }
    }
    
    func login() {
        
        self.isAnimating = true
        
        dataService.login(request: LoginAPIRequest(phone: selectedType == 0 ? checkForPhone(phone: phoneText) : emailText, password: passwordText, mobileToken: token))
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



import MapKit

class CountryDectectorViewController: UIViewController {
    var didDetectCountryCode: ((String?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Map view setup
        let mapView = MKMapView()
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        mapView.layoutIfNeeded()
        // Reverse geocoding map region center
        let location = CLLocation(
            latitude: mapView.region.center.latitude,
            longitude: mapView.region.center.longitude
        )
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, _ in
            self.didDetectCountryCode?(placemarks?.first?.isoCountryCode)
        }
    }
}
