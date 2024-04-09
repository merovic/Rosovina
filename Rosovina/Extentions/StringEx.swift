//
//  StringExt.swift
//  Teseppas Loylaty
//
//  Created by Amir Ahmed on 10/09/2022.
//

import Foundation

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

public extension String {
    func removePTags() -> String {
        // Define the regular expression pattern
        let pattern = "<\\/?p[^>]*>"
        
        do {
            // Create a regular expression object
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            // Replace matches with an empty string
            let modifiedString = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count), withTemplate: "")
            
            return modifiedString
        } catch {
            print("Error creating regular expression: \(error)")
            return self // Return the original string if an error occurs
        }
    }
    
    func removeHTMLTags() -> String {
        // Define the regular expression pattern to match HTML tags
        let pattern = "<[^>]+>"
        
        do {
            // Create a regular expression object
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            
            // Replace matches with an empty string
            let modifiedString = regex.stringByReplacingMatches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count), withTemplate: "")
            
            return modifiedString
        } catch {
            print("Error creating regular expression: \(error)")
            return self // Return the original string if an error occurs
        }
    }
}

public extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
