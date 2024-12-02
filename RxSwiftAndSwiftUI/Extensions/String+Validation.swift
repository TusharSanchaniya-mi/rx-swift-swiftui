//
//  String+Validation.swift
//  RxSwiftAndSwiftUI
//
//  Created by Mindinventory on 02/12/24.
//

import Foundation

extension String {
    
    var isValidEmailAddress: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
    
    var isValidPhoneNumber: Bool {
        let charcter = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString: NSArray = self.components(separatedBy: charcter) as NSArray
        return self == inputString.componentsJoined(by: "")
    }
    
    var isValidUserName: Bool {
        return isValidEmailAddress || isValidPhoneNumber
    }
    
    var isPasswordPassedMinLength: Bool {
        return self.count >= 8
    }
    
    var containNumber: Bool {
        
        let characters = CharacterSet.decimalDigits
        let range = self.rangeOfCharacter(from: characters)
        
        return range != nil
    }
    
    var containLowercase: Bool {
        let characters = CharacterSet.lowercaseLetters
        let range = self.rangeOfCharacter(from: characters)
        
        return range != nil
    }
    
    var containUppercase: Bool {
        let characters = CharacterSet.uppercaseLetters
        let range = self.rangeOfCharacter(from: characters)
        
        return range != nil
    }
    
    var isValidNewPassword: Bool {
        isPasswordPassedMinLength && containNumber && containLowercase && containUppercase
    }
    
    var isNotEmpty: Bool {
        return !self.isEmpty
    }
}
