// Copyright (c) 2015 Christian Tietze
// 
// See the file LICENSE for copying permission.

import AppKit

class Alerts {
    
    static func thankYouAlert() -> NSAlert? {
        
        if isRunningTests { return nil }
        
        let alert = NSAlert()
        alert.alertStyle = .InformationalAlertStyle
        alert.messageText = "Thank You for Purchasing!"
        alert.addButtonWithTitle("Continue")
        
        return alert
    }
    
    static func invalidLicenseCodeAlert() -> NSAlert? {
        
        if isRunningTests { return nil }
        
        let alert = NSAlert()
        alert.alertStyle = .CriticalAlertStyle
        alert.messageText = "Invalid combination of name and license code."
        alert.addButtonWithTitle("Close")
        
        return alert
    }
    
    static func trialDaysLeftAlert(daysLeft: Int) -> NSAlert? {
        
        if isRunningTests { return nil }
        
        let alert = NSAlert()
        alert.alertStyle = .InformationalAlertStyle
        alert.messageText = "You have \(daysLeft) days left on trial!"
        alert.addButtonWithTitle("Continue")
        
        return alert
    }
    
    static func trialUpAlert() -> NSAlert? {
        
        if isRunningTests { return nil }
        
        let alert = NSAlert()
        alert.alertStyle = .InformationalAlertStyle
        alert.messageText = "Your trial has expired."
        alert.addButtonWithTitle("Register")
        
        return alert
    }
}
