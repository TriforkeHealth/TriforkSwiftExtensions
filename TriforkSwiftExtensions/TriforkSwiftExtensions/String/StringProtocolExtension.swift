//
//  StringProtocolExtension.swift
//  TriforkSwiftExtensions
//
//  Created by Kim de Vos on 14/02/2019.
//  Copyright © 2019 Trifork A/S. All rights reserved.
//

import Foundation

public extension StringProtocol where Self.Index == String.Index {
    /// Returns a trimmmed string
    public var trim: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// /// Returns a sliced string that is inbetween from and to.
    ///
    /// - Parameters:
    ///   - from: The string that the range should start at
    ///   - to: The string the range should end at
    /// - Returns: If there is a valid range
    public func slice(from: Self, to: String) -> String? {

        guard let startRange = range(of: from)?.upperBound,
            let endRange = range(of: to, range: startRange..<endIndex)?.lowerBound else { return nil }
        return String(self[startRange..<endRange])
    }
}
