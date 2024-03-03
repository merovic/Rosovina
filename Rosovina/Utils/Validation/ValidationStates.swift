//
//  NameState.swift
//  TestProject
//
//  Created by PaySky106 on 29/01/2024.
//

import Foundation
import Combine

protocol Validatable {
    func validate(publisher: AnyPublisher<String, Never>) -> AnyPublisher<ValidationState, Never>
}

enum ValidationState: Equatable {
    case idle
    case error(ErrorState)
    case valid

    enum ErrorState: Equatable {
        case empty
        case invalidEmail
        case invalidPhone
        case tooShortPassword
        case passwordNeedsNum
        case passwordNeedsLetters
        case nameCantContainNumbers
        case nameCantContainSpecialChars
        case tooShortName
        case custom(String) // if default descriptions doesn't fit

        var description: String {
            switch self {
            case .empty:
                return "Field is empty."
            case .invalidEmail:
                return "Invalid email."
            case .invalidPhone:
                return "Invalid phone number."
            case .tooShortPassword:
                return "Password is too short."
            case .passwordNeedsNum:
                return "Password doesn't contain any numbers."
            case .passwordNeedsLetters:
                return "Password doesn't contain any letters."
            case .nameCantContainNumbers:
                return "Name can't contain numbers."
            case .nameCantContainSpecialChars:
                return "Name can't contain special characters."
            case .tooShortName:
                return "Name can't be less than two characters."
            case .custom(let text):
                return text
            }
        }
    }
}

extension Validatable {

    func isEmpty(publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }

    func isTooShort(publisher: AnyPublisher<String, Never>, count: Int) -> AnyPublisher<Bool, Never> {
        publisher
            .map { !($0.count >= count) }
            .eraseToAnyPublisher()
    }

    func hasNumbers(publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
         publisher
            .map { $0.containsNumbers() }
            .eraseToAnyPublisher()
    }

    func hasSpecialChars(publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .map { $0.hasSpecialCharacters() }
            .eraseToAnyPublisher()
    }
    
    func hasLetters(publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
        publisher
            .map { $0.contains(where: { $0.isLetter }) }
            .eraseToAnyPublisher()
    }
    
    func isEmail(publisher: AnyPublisher<String, Never>) -> AnyPublisher<Bool, Never> {
       publisher
            .map { $0.isValidEmail() }
            .eraseToAnyPublisher()
    }
    
    func isPhoneNumber(publisher: AnyPublisher<String, Never>, country: PhoneNumberCountry) -> AnyPublisher<Bool, Never> {
       publisher
            .map { $0.isValidPhone(forCountry: country) }
            .eraseToAnyPublisher()
    }

}

enum PhoneNumberCountry: String {
    case egypt = "EG"
    case saudiArabia = "SA"
    case unitedArabEmirates = "AE"
}

// String + Extensions
extension String {
    func hasSpecialCharacters() -> Bool {
        return stringFulfillsRegex(regex: ".*[^A-Za-z0-9].*")
    }
    
    func isValidEmail() -> Bool {
        return stringFulfillsRegex(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }
    
//    func isValidPhone() -> Bool {
//        return stringFulfillsRegex(regex: "^(010|011|012|015|10|11|12|15|2010|2011|2012|2015|05)\\d{8}$")
//    }
    
    func isValidPhone(forCountry country: PhoneNumberCountry) -> Bool {
        let regexPattern: String

        switch country {
        case .egypt:
            regexPattern = "^(010|011|012|015|10|11|12|15|2010|2011|2012|2015|05)\\d{8}$"
        case .saudiArabia:
            regexPattern = "^(05|009665|9665)[0-9]{8}$"
        case .unitedArabEmirates:
            regexPattern = "^(05|009715|9715)[0-9]{8}$"
        }

        return stringFulfillsRegex(regex: regexPattern)
    }
    
    func containsCapital() -> Bool {
        return stringFulfillsRegex(regex: ".*[A-Z]+.*")
    }
    
    func containsSmall() -> Bool {
        return stringFulfillsRegex(regex: ".*[a-z]+.*")
    }
    
    func containsNumbers() -> Bool {
        return stringFulfillsRegex(regex: ".*[0-9]+.*")
    }
    
    func containsSpecialChars() -> Bool {
        return stringFulfillsRegex(regex: ".*[!&^%$#@()/_*+-]+.*")
    }

    private func stringFulfillsRegex(regex: String) -> Bool {
        let textTest = NSPredicate(format: "SELF MATCHES %@", regex)
        guard textTest.evaluate(with: self) else {
            return false
        }
        return true
    }
}
