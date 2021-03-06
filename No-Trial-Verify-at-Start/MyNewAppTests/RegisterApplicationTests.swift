// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import Cocoa
import XCTest
import MyNewApp

class RegisterApplicationTests: XCTestCase {

    var service: RegisterApplication!

    let verifierDouble = TestVerifier()
    let writerDouble = TestWriter()
    let broadcasterDouble = TestBroadcaster()
    
    override func setUp() {
        
        super.setUp()
        
        service = RegisterApplication(licenseVerifier: verifierDouble, licenseWriter: writerDouble, changeBroadcaster: broadcasterDouble)
    }
    
    let irrelevantName = "irrelevant"
    let irrelevantLicenseCode = "irrelevant"
    
    func testRegister_DelegatesToVerifier() {
        
        let name = "a name"
        let licenseCode = "123-456"
        
        service.register(name, licenseCode: licenseCode)
        
        XCTAssert(hasValue(verifierDouble.didCallIsValidWith))
        if let values = verifierDouble.didCallIsValidWith {
            
            XCTAssertEqual(values.name, name)
            XCTAssertEqual(values.licenseCode, licenseCode)
        }
    }
    
    func testRegister_InvalidLicense_DoesntTryToStore() {
        
        verifierDouble.testValidity = false
        
        service.register(irrelevantName, licenseCode: irrelevantLicenseCode)
        
        XCTAssertFalse(hasValue(writerDouble.didStoreWith))
    }
    
    func testRegister_InvalidLicense_DoesntBroadcastChange() {
        
        verifierDouble.testValidity = false
        
        service.register(irrelevantName, licenseCode: irrelevantLicenseCode)
        
        XCTAssertFalse(hasValue(broadcasterDouble.didBroadcastWith))
    }
    
    func testRegister_ValidLicense_DelegatesToStore() {
        
        let name = "It's Me"
        let licenseCode = "0900-ACME"
        verifierDouble.testValidity = true
        
        service.register(name, licenseCode: licenseCode)
        
        XCTAssert(hasValue(writerDouble.didStoreWith))
        if let values = writerDouble.didStoreWith {
            
            XCTAssertEqual(values.name, name)
            XCTAssertEqual(values.licenseCode, licenseCode)
        }
    }
    
    func testRegister_ValidLicense_BroadcastsChange() {
        
        let name = "Hello again"
        let licenseCode = "fr13nd-001"
        verifierDouble.testValidity = true
        
        service.register(name, licenseCode: licenseCode)
        
        XCTAssert(hasValue(broadcasterDouble.didBroadcastWith))
        if let licenseInfo = broadcasterDouble.didBroadcastWith {
            
            switch licenseInfo {
            case .Unregistered: XCTFail("should be registered")
            case let .Registered(license):
                XCTAssertEqual(license.name, name)
                XCTAssertEqual(license.licenseCode, licenseCode)
            }
        }
    }


    // MARK: -
    
    class TestWriter: LicenseWriter {
        
        var didStoreWith: (licenseCode: String, name: String)?
        override func storeLicenseCode(licenseCode: String, forName name: String) {
            
            didStoreWith = (licenseCode, name)
        }
    }
    
    class TestVerifier: LicenseVerifier {
        
        init() {
            super.init(appName: "irrelevant app name")
        }
        
        var testValidity = false
        var didCallIsValidWith: (licenseCode: String, name: String)?
        override func licenseCodeIsValid(licenseCode: String, forName name: String) -> Bool {
            
            didCallIsValidWith = (licenseCode, name)
            
            return testValidity
        }
    }
    
    class TestBroadcaster: LicenseChangeBroadcaster {
        
        var didBroadcastWith: LicenseInformation?
        override func broadcast(licenseInformation: LicenseInformation) {
            
            didBroadcastWith = licenseInformation
        }
    }
}
