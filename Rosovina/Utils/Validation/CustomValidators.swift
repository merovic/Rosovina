//
//  CustomValidators.swift
//  TestProject
//
//  Created by PaySky106 on 29/01/2024.
//

import Foundation
import Combine
import UIKit

protocol Validator {
    func validateText(
        validationType: ValidatorType,
        publisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<ValidationState, Never>
}

enum ValidatorType {
    case email
    case password
    case phone(country: PhoneNumberCountry)
    case name
}

enum ValidatorFactory {
    static func validateForType(type: ValidatorType) -> Validatable {
        switch type {
        case .email:
            return EmailValidator()
        case .password:
            return PasswordValidator()
        case .name:
            return NameValidator()
        case .phone(let country):
            return PhoneValidator(country: country)
        }
    }
}

extension Validator {
    func validateText(
        validationType: ValidatorType,
        publisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {
        let validator = ValidatorFactory.validateForType(type: validationType)
        return validator.validate(publisher: publisher)
    }
}

extension Publisher where Self.Output == String, Failure == Never {
    func validateText(validationType: ValidatorType) -> AnyPublisher<ValidationState, Never> {
        let validator = ValidatorFactory.validateForType(type: validationType)
        return validator.validate(publisher: self.eraseToAnyPublisher())
    }
}
