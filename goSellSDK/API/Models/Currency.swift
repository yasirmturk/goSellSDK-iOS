//
//  Currency.swift
//  goSellSDK
//
//  Copyright © 2018 Tap Payments. All rights reserved.
//

/// Currency structure.
@objcMembers public final class Currency: NSObject {
    
    // MARK: - Public -
    // MARK: Properties
    
    /// Lowercased 3-letters currency ISO code.
    public let isoCode: String
    
    // MARK: Methods
    
    /// Initializes currency with 3-lettered ISO code.
    ///
    /// - Parameter isoCode: ISO code.
    /// - Throws: Invalid currency exception.
    public init(isoCode: String) throws {
        
        let code = isoCode.lowercased()
        
        guard Currency.allISOCodes.contains(code) else {
            
            let userInfo = [ErrorConstants.UserInfoKeys.currencyCode: code]
            let underlyingError = NSError(domain: ErrorConstants.internalErrorDomain, code: InternalError.invalidCurrency.rawValue, userInfo: userInfo)
            throw TapSDKKnownError(type: .internal, error: underlyingError, response: nil)
        }
        
        self.isoCode = code
        
        super.init()
    }
    
    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        
        return lhs.isoCode == rhs.isoCode
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        
        guard let other = object as? Currency else { return false }
        return self.isoCode == other.isoCode
    }
    
    // MARK: - Private -
    // MARK: Properties
    
    private static let allISOCodes = Locale.isoCurrencyCodes.map { $0.lowercased() }
}

// MARK: - Encodable
extension Currency: Encodable {
    
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        try container.encode(self.isoCode)
    }
}

// MARK: - Decodable
extension Currency: Decodable {
    
    public convenience init(from decoder: Decoder) throws {
        
        let container = try decoder.singleValueContainer()
        let code = try container.decode(String.self)
        
        try self.init(isoCode: code)
    }
}