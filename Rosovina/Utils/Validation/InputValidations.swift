//
//  EmailValidation.swift
//  TestProject
//
//  Created by PaySky106 on 29/01/2024.
//

import Foundation
import Combine

struct NameValidator: Validatable {
    func validate(
        publisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {

        Publishers.CombineLatest4(
            isEmpty(publisher: publisher),
            isTooShort(publisher: publisher, count: 2),
            hasNumbers(publisher: publisher),
            hasSpecialChars(publisher: publisher)
        )
        .removeDuplicates(by: { prev, curr in
            prev == curr
        })
        .map { isEmpty, tooShort, hasNumbers, hasSpecialChars in
            if isEmpty { return .error(.empty) }
            if tooShort { return .error(.tooShortName) }
            if hasNumbers { return .error(.nameCantContainNumbers) }
            if hasSpecialChars { return .error(.nameCantContainSpecialChars) }
            return .valid
        }
        .eraseToAnyPublisher()
    }
}

struct EmailValidator: Validatable {
    func validate(
        publisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<ValidationState, Never>{

        Publishers.CombineLatest(
            isEmpty(publisher: publisher),
            isEmail(publisher: publisher)
        )
        .removeDuplicates(by: { prev, curr in
            prev == curr
        })
        .map { isEmpty, isEmail in
            if isEmpty { return .error(.empty) }
            if !isEmail { return .error(.invalidEmail) }
            return .valid
        }
        .eraseToAnyPublisher()
    }
}


struct PasswordValidator: Validatable {
    func validate(
        publisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {

        Publishers.CombineLatest(
            isEmpty(publisher: publisher),
            isTooShort(publisher: publisher, count: 6)
        )
        .removeDuplicates(by: { prev, curr in
            prev == curr
        })
        .map { isEmpty, tooShort in
            if isEmpty { return .error(.empty) }
            if tooShort { return .error(.tooShortPassword) }
            return .valid
        }
        .eraseToAnyPublisher()
    }
}


struct PhoneValidator: Validatable {
    var country: PhoneNumberCountry
    init(country: PhoneNumberCountry) {
        self.country = country
    }
    func validate(
        publisher: AnyPublisher<String, Never>
    ) -> AnyPublisher<ValidationState, Never> {

        Publishers.CombineLatest(
            isEmpty(publisher: publisher),
            isPhoneNumber(publisher: publisher, country: country)
        )
        .removeDuplicates(by: { prev, curr in
            prev == curr
        })
        .map { isEmpty, isPhoneNumber in
            if isEmpty { return .error(.empty) }
            if !isPhoneNumber { return .error(.invalidPhone) }
            return .valid
        }
        .eraseToAnyPublisher()
    }
}
