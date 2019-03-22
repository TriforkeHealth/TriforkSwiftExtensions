//
//  StringExtension.swift
//  TriforkSwiftExtensions
//
//  Created by Thomas Kalhøj Clemensen on 28/08/2017.
//  Copyright © 2017 Trifork A/S. All rights reserved.
//

import Foundation

public extension String {
    
    //MARK: - Encoding
    
    /// Returns a new and URL encoded instance of the receiver, without URL encoding query characters like :, ?, &, /, etc.
    public var urlEncodedWithQuery: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? self
    }
    
    /// Returns a url encoded strings with alphanumerics as allowed characters
    public var urlEncoded: String {
        let allowedCharacterSet: CharacterSet = CharacterSet(charactersIn: "!*'();:@&=+$,/?%#[] ").inverted
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? self
    }
    
    /// Returns a base64 encoded instance of the receiver.
    public var base64Encoded: String? {
        return self.data(using: .utf8)?.base64EncodedString()
    }
    
    /// Returns a string decoded from the base64 encoded receiver, returns `nil` if the receiver is not base64 encoded.
    public var decodeBase64: String? {
        let result: String?
        if let data: Data = Data(base64Encoded: self, options: .ignoreUnknownCharacters) {
            result = String(data: data, encoding: .utf8)
        }
        else {
            result = nil
        }
        return result
    }
    
    //MARK: - Conversion
    
    /// Creates a URL instance from the receiver. Returns `nil` if the string is an invalid URL.
    public func toURL() -> URL? {
        return URL(string: self)
    }
    
    /// Converts the receiver to UTF-8 encoded `Data` instance.
    public func toData() -> Data? {
        return self.data(using: .utf8)
    }
    
    //MARK: - RegEx

    /// Check if the receiver matches the regular expression defined in a string format.
    ///
    /// - Parameters:
    ///   - regExp: Regular expression to match
    ///   - options: Options the expression uses. Default is empty
    /// - Returns: return `true` if there is one match or more.
    public func isMatching(regEx regExp: String, options: NSRegularExpression.Options = []) -> Bool {
        do {
            let matcher: NSRegularExpression = try NSRegularExpression(pattern: regExp, options: options)
            let searchRange = NSRange(location: 0, length: self.length)
            return matcher.firstMatch(in: self, options: [], range: searchRange) != nil
        } catch let error as NSError {
            TSELogger.log(message: "Unable to create regular expression from: \(regExp): \(error.localizedDescription)")
            return false
        }
    }

    /// Check if the receiver matches the regular expression defined in a string format.
    ///
    /// The check is case insensitive
    @available(*, deprecated, message: "This function is replaced by `isMatching`. isMatching is **NOT** not `.caseInsensitive`. It can be added as an option.", renamed: "isMatching")
    public func matches(withRegularExpression regExp: String) -> Bool {
        return isMatching(regEx: regExp, options: .caseInsensitive)
    }

    /// Returns all components from the regular expression matching
    ///
    /// - Parameter pattern: regular expression. If not valid it return an empty array.
    /// - Returns: A list of possible results. First item in list is full match, the rest is possible groups.
    public func matches(regEx pattern: String) -> [String] {
        guard let matcher = try? NSRegularExpression(pattern: pattern, options: []) else {
            return []
        }

        return matcher.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
            .flatMap { result -> [String] in
                var values = [String]()
                for i in 0..<result.numberOfRanges {
                    guard let range = Range(result.range(at: i), in: self) else { continue }
                    values.append(String(self[range]))
                }

                return values
        }
    }

    /// Returns all components from the regular expression matching
    @available(*, deprecated, message: "This function removes the 'fullmatch'. Pleae use the new one.", renamed: "matches")
    public func allMatches(withRegularExpression pattern: String) -> [String] {
        if let matcher = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options()) {
            let str = self as NSString
            var matches = [String]()
            matcher.enumerateMatches(in: self, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, str.length), using: { (optResult, flags, stop) -> Void in
                if let result = optResult, result.numberOfRanges > 1 {
                    for t in (1 ... (result.numberOfRanges - 1)) {
                        let s = str.substring(with: result.range(at: t))
                        matches.append(s)
                    }
                }
            })
            return matches
        }
        return []
    }
    
    //MARK: - Validation
    /// Checks if the string contains valid phone number
    public var isPhoneNumber: Bool {
        let detector: NSDataDetector? = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
        return detector?.matches(in: self, options: [], range: NSMakeRange(0, self.length)).count ?? 0 > 0
    }
    
    /// Check if the string contains a valid email
    public var isEmail: Bool {
        return self.isMatching(regEx: "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$")
    }
    
    //MARK: - Other
    
    /// Returns the number of characters in the string.
    public var length: Int {
        return self.count
    }
}
