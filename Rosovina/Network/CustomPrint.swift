//
//  CustomPrint.swift
//  YallaSuperApp
//
//  Created by Amir Ahmed on 05/12/2022.
//

import Foundation
import SwiftyJSON

struct CustomPrint{
 
    static func swiftyAPIPrint(request:URLRequest,response:Any,isDecodable:Bool){
        
        print("* \n*")
        print("*****************API Request URL***************** \n* \n*")
        print("📗 Request: \(request)")
        print("* \n*")
        print("*****************API Request Body***************** \n* \n*")
        
        
        if let requestBody = request.httpBody {
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: requestBody, options: [])
                    print("📗 Request Body: \(jsonArray)")
                }
                catch {
                    print("Error: \(error)")
                }
        }else{
            print("📗 No Request Body - Parameters Embedded in URL")
        }
        
        print("* \n*")
        print("*****************API Decoded Response******************** \n* \n*")
        if(isDecodable){
            dump("\n📗 Response: \(response)\n")
        }else{
            print("\n📗 Response: \(response)\n")
        }
        print("********************************** \n* \n*")
    }
    
    static func swiftyAPIPrintString(data: Data?){
        print("* \n*")
        print("*****************API JSON Response******************** \n* \n*")
        do {
            if let json = data {
                let data = try JSON(data: json)
                print("\n📗 Response: \(data)\n")
            }
        } catch {
            print(error)
        }
        print("********************************** \n* \n*")
    }
    
    static func swiftyAPIPrintError(message: String){
        print("* \n*")
        print("*****************API Error Message******************** \n* \n*")
        print("\n📕 Error: \(message)\n")
        print("********************************** \n* \n*")
    }
    
}

enum LogType: String{
        case error
        case warning
        case success
        case action
        case canceled
}

class Logger{
 static func log(_ logType:LogType,_ message:String){
        switch logType {
        case LogType.error:
            print("\n📕 Error: \(message)\n")
        case LogType.warning:
            print("\n📙 Warning: \(message)\n")
        case LogType.success:
            print("\n📗 Success: \(message)\n")
        case LogType.action:
            print("\n📘 Action: \(message)\n")
        case LogType.canceled:
            print("\n📓 Cancelled: \(message)\n")
        }
    }

}
