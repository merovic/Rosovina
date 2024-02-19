//
//  APIRouter.swift
//  CombineNetworking
//
//  Created by Amir Ahmed on 11/12/2023.
//

import Foundation
import Alamofire

enum APIRouter: URLRequestConvertible {
    
    // MARK: - AuthModule
    case login(request: LoginAPIRequest)
    case register(request: RegistrationAPIRequest)
    case check_phone(request: PhoneAPIRequest)
    case otp_send(request: OTPSendAPIRequest)
    case otp_check(request: OTPCheckAPIRequest)
    case generate_token(request: PhoneAPIRequest)
    case reset_password(request: ResetPasswordAPIRequest, token:String)
    case logout
    
    // MARK: - HomeModule
    case home(deviceToken: String, cityID: Int)
    case getProducts(request: GetProductsAPIRequest)
    case product_details(productID: String)
    case getCategories(isOccasion: Bool)
    
    // MARK: - CartModule
    case getCart(deviceToken: String)
    case updateCart(request: UpdateCartAPIRequest)
    case getGiftCards
    case checkPromoCode(request: CheckPromoCodeAPIRequest)
        
    // MARK: - WishlistModule
    case getWishlist(deviceToken: String)
    case addToWishList(request: WishlistAPIRequest)
    case removeFromWishList(request: WishlistAPIRequest)
    
    // MARK: - AddressModule
    case getUserAddresses
    case addAddress(request: AddUserAddress)
    case removeAddress(addressID: String)
    case updateAddress(addressID: String, request: AddUserAddress)
    case getCountries
    case getCities(countryID: String)
    case getAreas(cityID: String)
    
    // MARK: - CheckoutModule
    case createOrder(request: CreateOrderAPIRequest)
    case confirmOrder(request: ConfirmOrderAPIRequest)
    case getSlots(date: String)
    
    // MARK: - ProfileModule
    case myOrders
    case myOrderDetails(orderID: String)
    case updateAccount(name: String, email: String)
    case deleteAccount
    case addReview(request: AddReviewAPIRequest)
    
    // MARK: - NotificationsModule
    case notifications(deviceToken: String)
    
    
    // MARK: - RequestParameterMethod
    private var requestParameter: RequestParameterMethod? {
        switch self {
        case .home, .login,.register,.otp_send,.otp_check,.reset_password,.check_phone,.generate_token, .getCart, .updateCart, .getWishlist, .addToWishList, .removeFromWishList, .getProducts, .addAddress, .updateAddress, .createOrder, .notifications, .updateAccount, .checkPromoCode, .addReview, .confirmOrder:
            return .formParam
        case .logout, .getUserAddresses, .getCountries, .myOrders, .getGiftCards, .deleteAccount:
            return nil
        case .product_details, .removeAddress, .myOrderDetails:
            return .pathParam
        case .getCities, .getAreas, .getCategories, .getSlots:
            return .queryParam
        }
    }
    
    // MARK: - contentType
    private var contentType: String {
        switch self {
        case .login, .register, .otp_send, .otp_check, .reset_password, .check_phone, .generate_token, .logout, .home, .product_details, .getCart, .updateCart, .getWishlist, .addToWishList, .removeFromWishList, .getProducts, .addAddress, .updateAddress, .removeAddress, .getUserAddresses, .getCountries, .getCities, .getAreas, .createOrder, .myOrders, .myOrderDetails, .notifications, .getGiftCards, .checkPromoCode, .deleteAccount, .getCategories, .addReview, .confirmOrder, .getSlots:
            return "application/json"
        case .updateAccount:
            return "multipart/form-data"
        }
    }
    
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .home, .login,.register,.otp_send, .otp_check,.reset_password,.check_phone,.generate_token, .product_details, .getCart, .updateCart, .getWishlist, .addToWishList, .removeFromWishList, .getProducts, .addAddress, .updateAddress, .removeAddress, .createOrder, .notifications, .updateAccount, .checkPromoCode, .deleteAccount, .addReview, .confirmOrder, .getSlots:
            return .post
        case .logout, .getUserAddresses, .getCountries, .getCities, .getAreas, .myOrders, .myOrderDetails, .getGiftCards, .getCategories:
            return .get
        }
    }
    
    // MARK: - EndPoint
    private var endpoint: String {
        switch self {
        case .login,.register,.otp_send, .otp_check,.reset_password,.check_phone,.generate_token, .logout, .home, .product_details, .getCart, .updateCart, .getWishlist, .addToWishList, .removeFromWishList, .getProducts, .addAddress, .updateAddress, .removeAddress, .getUserAddresses, .getCountries, .getCities, .getAreas, .createOrder, .myOrders, .myOrderDetails, .notifications, .updateAccount, .getGiftCards, .checkPromoCode, .deleteAccount, .getCategories, .addReview, .confirmOrder, .getSlots:
            return RemoteServers.ProductionServer.baseURL
        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .register:
            return "/auth/register"
        case .otp_send:
            return "/auth/send-otp"
        case .otp_check:
            return "/auth/verify"
        case .reset_password(request: _, token: let token):
            return "/auth/reset-password/" + token
        case .check_phone:
            return "/auth/check-phone"
        case .generate_token:
            return "/auth/generate-token"
        case .logout:
            return "/logout"
        case .home:
            return "/home"
        case .getProducts:
            return "/product"
        case .product_details(productID: let productID):
            return "/product/show/" + productID
        case .getCart:
            return "/cart/get"
        case .updateCart:
            return "/cart/update"
        case .getWishlist:
            return "/wishlist/get"
        case .addToWishList:
            return "/wishlist/create"
        case .removeFromWishList:
            return "/wishlist/delete-item"
        case .getUserAddresses:
            return "/user/address"
        case .addAddress:
            return "/user/address/create"
        case .removeAddress(addressID: let addressID):
            return "/user/address/delete/" + addressID
        case .updateAddress(addressID: let addressID, request: _):
            return "/user/address/update/" + addressID
        case .getCountries:
            return "/country/all"
        case .getCities:
            return "/country/cities"
        case .getAreas:
            return "/country/areas"
        case .createOrder:
            return "/order/create"
        case .myOrders:
            return "/order/my-orders"
        case .myOrderDetails(orderID: let orderID):
            return "/order/" + orderID
        case .notifications:
            return "/notification/get"
        case .updateAccount:
            return "/profile/update"
        case .getGiftCards:
            return "/cart/gift-cards"
        case .checkPromoCode:
            return "/promo-code/check"
        case .deleteAccount:
            return "/profile/delete"
        case .getCategories:
            return "/category"
        case .addReview:
            return "/product/add-review"
        case .confirmOrder:
            return "/order/confirm"
        case .getSlots:
            return "/slot/get-slots"
        }
    }
    
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(request: let request):
            return request.dictionary
        case .register(request: let request):
            return request.dictionary
        case .otp_send(request: let request):
            return request.dictionary
        case .otp_check(request: let request):
            return request.dictionary
        case .reset_password(request: let request, token: _):
            return request.dictionary
        case .check_phone(request: let request):
            return request.dictionary
        case .generate_token(request: let request):
            return request.dictionary
        case .logout:
            return nil
        case .home(deviceToken: let deviceToken, cityID: let cityID):
            return ["device_token": deviceToken, "city_id" : cityID]
        case .product_details:
            return nil
        case .getCart(deviceToken: let deviceToken):
            return ["device_token": deviceToken]
        case .updateCart(request: let request):
            return request.dictionary
        case .getWishlist(deviceToken: let deviceToken):
            return ["device_token": deviceToken]
        case .addToWishList(request: let request):
            return request.dictionary
        case .removeFromWishList(request: let request):
            return request.dictionary
        case .getProducts(request: let request):
            return request.dictionary
        case .getUserAddresses:
            return nil
        case .addAddress(request: let request):
            return request.dictionary
        case .removeAddress(addressID: _):
            return nil
        case .updateAddress(addressID: _, request: let request):
            return request.dictionary
        case .getCountries:
            return nil
        case .getCities(countryID: let countryID):
            return ["country_id": countryID]
        case .getAreas(cityID: let cityID):
            return ["city_id": cityID]
        case .createOrder(request: let request):
            return request.dictionary
        case .myOrders:
            return nil
        case .myOrderDetails:
            return nil
        case .notifications(deviceToken: let deviceToken):
            return ["device_token": deviceToken]
        case .updateAccount(name: let name, email: let email):
            return ["name": name, "email": email]
        case .getGiftCards:
            return nil
        case .checkPromoCode(request: let request):
            return request.dictionary
        case .deleteAccount:
            return nil
        case .getCategories(isOccasion: let isOccasion):
            return ["is_occasion": isOccasion]
        case .addReview(request: let request):
            return request.dictionary
        case .confirmOrder(request: let request):
            return request.dictionary
        case .getSlots(date: let date):
            return ["date": date]
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        
        let url = try endpoint.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        
        // HTTPMethod
        urlRequest.httpMethod = method.rawValue
        
        // Header
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        urlRequest.setValue("Bearer " + LoginDataService.shared.getAuthToken(), forHTTPHeaderField: HTTPHeaderField.authentication.rawValue)
        
        // Parameters
        switch requestParameter {
        case .queryParam:
            if let parameters = parameters {
                urlRequest = try URLEncoding.queryString.encode(urlRequest, with: parameters)} else{
                urlRequest = try URLEncoding.queryString.encode(urlRequest, with: nil)
            }
        case .pathParam:
            break
        case .formParam:
            if let parameters = parameters {
                do {urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])} catch {
                    throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))}
            }
        case .none:
            break
        }
       
        return urlRequest
    }
}
