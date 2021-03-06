// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Foundation

public struct License {
    
    public let name: String
    public let licenseCode: String
    
    public init(name: String, licenseCode: String) {
        
        self.name = name
        self.licenseCode = licenseCode
    }
    
    public enum UserDefaultsKeys: String, CustomStringConvertible {
        
        case Name = "licensee"
        case LicenseCode = "license_code"
        
        public var description: String { return rawValue }
    }
}

extension License: Equatable { }

public func ==(lhs: License, rhs: License) -> Bool {
    
    return lhs.name == rhs.name && lhs.licenseCode == rhs.licenseCode
}

public enum LicenseInformation {
    
    case Registered(License)
    case OnTrial(TrialPeriod)
    case TrialUp
}

extension LicenseInformation: Equatable { }

public func ==(lhs: LicenseInformation, rhs: LicenseInformation) -> Bool {
    
    switch (lhs, rhs) {
    case (.TrialUp, .TrialUp): return true
    case let (.OnTrial(lPeriod), .OnTrial(rPeriod)): return lPeriod == rPeriod
    case let (.Registered(lLicense), .Registered(rLicense)): return lLicense == rLicense
    default: return false
    }
}
