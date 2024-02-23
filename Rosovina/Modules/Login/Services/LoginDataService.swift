//
//  DataService.swift
//  Abshare
//
//  Created by Apple on 09/10/2021.
//

import Foundation
import UIKit

class LoginDataService {
    
    static let shared = LoginDataService()
    
    private init(){}
        
    private let isLoggedIn = "isLoggedIn"
    
    private let authToken = "authToken"
    
    private let firebaseToken = "firebaseToken"
    
    private let id = "id"
    
    private let imageURL = "imageURL"
    
    private let fullName = "fullName"
    
    private let mobileNumber = "mobileNumber"
    
    private let dateOfBirth = "dateOfBirth"
    
    private let password = "password"
    
    private let gender = "gender"
    
    private let emailAddress = "emailAddress"
    
    private let badgeNumber = "badgeNumber"
    
    private let firstLaunchFromTermination = "firstLaunchFromTermination"
    
    static let googleApiKey = "AIzaSyCCiAbMIfF_IpdCxFKB7CZTgqbJrlOc09o"
    
    private let totalPrice = "totalPrice"
    
    private let animationD = "animationD"
    
    private let userCountry = "userCity"
    
    private let userCity = "userCity"
        
    func setLogin(){
        UserDefaults.standard.set(true, forKey: self.isLoggedIn)
    }
    
    func setLogout(){
        UserDefaults.standard.set(false, forKey: self.isLoggedIn)
    }
    
    func isLogedIn() -> Bool {
        return UserDefaults.standard.bool(forKey: self.isLoggedIn)
    }
    
    func newDeviceLoggedIn(_ context: UIViewController) {
        self.setLogout()
        let vc = LoginView()
        context.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setFirstLaunchFromTermination() -> Bool {
        let hasBeenLaunchedBeforeFlag = "hasBeenLaunchedBeforeFlag"
        let isFirstLaunch = !UserDefaults.standard.bool(forKey: hasBeenLaunchedBeforeFlag)
        if (isFirstLaunch) {
            UserDefaults.standard.set(true, forKey: hasBeenLaunchedBeforeFlag)
            UserDefaults.standard.synchronize()
        }
        return isFirstLaunch
    }
    
    func setUserCountry(country: GeoLocationAPIResponseElement){
        let defaults = UserDefaults.standard
        do {
            let encodedData = try JSONEncoder().encode(country)
            defaults.set(encodedData, forKey: self.userCountry)
        } catch {
            print("Error encoding object: \(error)")
        }
    }
    
    func getUserCountry() -> GeoLocationAPIResponseElement{
        if let savedData = UserDefaults.standard.data(forKey: self.userCountry) {
            do {
                let decodedObject = try JSONDecoder().decode(GeoLocationAPIResponseElement.self, from: savedData)
                return decodedObject
            } catch {
                return GeoLocationAPIResponseElement(id: 1, name: "Saudi Arabia", image_path: "")
            }
        }else{
            return GeoLocationAPIResponseElement(id: 1, name: "Saudi Arabia", image_path: "")
        }
    }
    
    func setUserCity(city: GeoLocationAPIResponseElement){
        let defaults = UserDefaults.standard
        do {
            let encodedData = try JSONEncoder().encode(city)
            defaults.set(encodedData, forKey: self.userCity)
        } catch {
            print("Error encoding object: \(error)")
        }
    }
    
    func getUserCity() -> GeoLocationAPIResponseElement{
        if let savedData = UserDefaults.standard.data(forKey: self.userCity) {
            do {
                let decodedObject = try JSONDecoder().decode(GeoLocationAPIResponseElement.self, from: savedData)
                return decodedObject
            } catch {
                return GeoLocationAPIResponseElement(id: 1, name: "Jeddah", image_path: "")
            }
        }else{
            return GeoLocationAPIResponseElement(id: 1, name: "Jeddah", image_path: "")
        }
    }
    
    func isFirstLaunchFromTermination() -> Bool {
        return UserDefaults.standard.bool(forKey: self.firstLaunchFromTermination)
    }
    
    func getID() -> String{
        return UserDefaults.standard.string(forKey: self.id) ?? ""
    }
    
    func setID(id: Int){
        UserDefaults.standard.set(String(id), forKey: self.id)
    }
    
    func getFullName() -> String{
        return UserDefaults.standard.string(forKey: self.fullName) ?? ""
    }
    
    func setFullName(name: String){
        UserDefaults.standard.set(name, forKey: self.fullName)
    }
    
    func getImageURL() -> String{
        return UserDefaults.standard.string(forKey: self.imageURL) ?? ""
    }
    
    func setImageURL(url: String){
        UserDefaults.standard.set(url, forKey: self.imageURL)
    }
    
    func getMobileNumber() -> String{
       return UserDefaults.standard.string(forKey: self.mobileNumber) ?? ""
    }
    
    func setMobileNumber(number: String){
        UserDefaults.standard.set(number, forKey: self.mobileNumber)
    }
    
    func getDateOfBirth() -> String{
        return UserDefaults.standard.string(forKey: self.dateOfBirth) ?? ""
    }
    
    func setDateOfBirth(date: String){
        UserDefaults.standard.set(date, forKey: self.dateOfBirth)
    }
    
    func getGender() -> String{
        return UserDefaults.standard.string(forKey: self.gender) ?? ""
    }
    
    func setGender(gender: String){
        UserDefaults.standard.set(gender, forKey: self.gender)
    }
    
    func getEmail() -> String{
        return UserDefaults.standard.string(forKey: self.emailAddress) ?? ""
    }
    
    func setEmail(email: String){
        UserDefaults.standard.set(email, forKey: self.emailAddress)
    }
    
    func getPassword() -> String{
        return UserDefaults.standard.string(forKey: self.password) ?? ""
    }
    
    func setPassword(password: String){
        UserDefaults.standard.set(password, forKey: self.password)
    }
    
    func getBadgeNumber() -> String{
        return UserDefaults.standard.string(forKey: self.badgeNumber) ?? ""
    }
    
    func setBadgeNumber(number: String){
        UserDefaults.standard.set(number, forKey: self.badgeNumber)
    }
    
    func setAuthToken(token: String){
        UserDefaults.standard.set(token, forKey: self.authToken)
    }
    
    func getAuthToken() -> String{
        return UserDefaults.standard.string(forKey: self.authToken) ?? ""
    }
    
    func setFirebaseToken(token: String){
        UserDefaults.standard.set(token, forKey: self.firebaseToken)
    }
    
    func getFirebaseToken() -> String{
        return UserDefaults.standard.string(forKey: self.firebaseToken) ?? ""
    }
    
    func setTotalPrice(totalPrice: Float){
        UserDefaults.standard.set(totalPrice, forKey: self.totalPrice)
    }
    
    func getTotalPrice() -> Float{
        return UserDefaults.standard.float(forKey: self.totalPrice)
    }
    
    func getAnimation() -> String{
        return UserDefaults.standard.string(forKey: self.animationD) ?? ""
    }
    
    func setAnimation(name: String){
        UserDefaults.standard.set(name, forKey: self.animationD)
    }
    
//    func setClient(_ client:Client){
//        SaveDictionaryUserDefault(dictionaryName: self.client).saveDictionary(sourceDictionary: client.dictionary)
//    }
//
//    func getClient() -> Client {
//        return SaveDictionaryUserDefault(dictionaryName: self.client).getObjectValue()
//    }
//
//    func updateImage(imageURL:String){
//        SaveDictionaryUserDefault(dictionaryName: self.client).updateValue(withNewValue: imageURL, forKey: "profilepicture")
//    }
//
//    func updatePoints(points:String){
//        SaveDictionaryUserDefault(dictionaryName: self.client).updateValue(withNewValue: points, forKey: "points")
//    }
}
