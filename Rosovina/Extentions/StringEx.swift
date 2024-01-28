//
//  StringExt.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 10/09/2022.
//

import Foundation

extension String{
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPhone() -> Bool {
        let regEx = "^(010|011|012|015|10|11|12|15|2010|2011|2012|2015|05)\\d{8}$"
        let phoneCheck = NSPredicate(format: "SELF MATCHES %@", regEx)
        return phoneCheck.evaluate(with: self)
    }
    
    func containsCapital() -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        return texttest.evaluate(with: self)
    }
    
    func containsSmall() -> Bool {
        let capitalLetterRegEx  = ".*[a-z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        return texttest.evaluate(with: self)
    }
    
    func containsNumbers() -> Bool {
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        return texttest1.evaluate(with: self)
    }
    
    func containsSpecialChars() -> Bool {
        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        return texttest2.evaluate(with: self)
    }
}

extension String {
    func trimmingWhitespace() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

public extension String {
    
    var replacedArabicDigitsWithEnglish: String {
        var str = self
        let map = ["٠": "0",
                   "١": "1",
                   "٢": "2",
                   "٣": "3",
                   "٤": "4",
                   "٥": "5",
                   "٦": "6",
                   "٧": "7",
                   "٨": "8",
                   "٩": "9",
                   " ": ""]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
    
    var replacedEnglishDigitsWithArabic: String {
        var str = self
        let map = ["0": "٠",
                   "1": "١",
                   "2": "٢",
                   "3": "٣",
                   "4": "٤",
                   "5": "٥",
                   "6": "٦",
                   "7": "٧",
                   "8": "٨",
                   "9": "٩",
                   " ": ""]
        map.forEach { str = str.replacingOccurrences(of: $0, with: $1) }
        return str
    }
}

public extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard
            let data = self.data(using: .utf8)
            else { return nil }
        do {
            return try NSAttributedString(data: data, options: [
                NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue
                ], documentAttributes: nil)
        } catch let error as NSError {
            print(error.localizedDescription)
            return  nil
        }
    }

    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
