//
//  VeriJSON.swift
//  VeriJSON-Swift
//
//  Created by Du, Xiaochen (Harry) on 3/6/15.
//  Copyright (c) 2015 Where Here. All rights reserved.
//

import Foundation
import UIKit

enum VeriJSONErrorCode : Int {
    case InvalidPattern = 1
}

let VeriJSONErrorDomain = "VeriJSONErrorDomain"

class VeriJSON {

    func verifyJSON(json:AnyObject?, pattern:AnyObject?) -> Bool {

        do {
            try verifyJSONThrow(json, pattern: pattern)
            return true
        } catch {
            return false
        }
    }
    

    
    func verifyJSONThrow(json:AnyObject?, pattern:AnyObject?) throws {
        var error: NSError! = NSError(domain: "Migrator", code: 0, userInfo: nil)

        if let pattern: AnyObject = pattern {
            
            if let json: AnyObject = json {
                
                let patternStack:NSMutableArray = NSMutableArray(array:[""])
                let valid = verifyValue(json, pattern: pattern, permitNull: false, patternStack: patternStack)
                if (!valid && true) {
                    error = buildErrorFromPatternStack(patternStack)
                }
                if valid {
                    return
                }
                throw error
            } else {
                //json missing -> Reject any
                throw error
            }

        } else {
            //pattern missing -> Accept any
            return
            
        }
        
    }
    
    internal func verifyValue(value:AnyObject, pattern:AnyObject, permitNull:Bool, patternStack:NSMutableArray) -> Bool {

        
        switch value {
        case let value as NSNull:
            return permitNull
        case let value as NSDictionary:
            if let pattern = pattern as? NSDictionary {
                return verifyObject(value, pattern: pattern, patternStack: patternStack)
            } else {
                return false
            }
        case let value as NSArray:
            if let pattern = pattern as? NSArray {
                return verifyArray(value, pattern:pattern, patternStack: patternStack)
            } else {
                return false
            }
        default:
            if let pattern = pattern as? NSString {
                
                return verifyBaseValue(value, pattern:pattern as String, patternStack:patternStack)
            } else {
                return false
            }

        }
    }
    
    
    internal func verifyObject(value:NSDictionary, pattern:NSDictionary, patternStack:NSMutableArray) -> Bool {

        var valid = true
        pattern.enumerateKeysAndObjectsUsingBlock { (attributeName, attributePattern, stop) -> Void in
            patternStack.addObject(attributeName)
            let attributeValid = self.verifyObject(value,attributeName:attributeName as! NSString, attributePattern:attributePattern, patternStack:patternStack)
            if attributeValid {
                patternStack.removeLastObject()
            } else {
                valid = false
                stop.memory = true
            }
        }
        return valid
    }
    
    internal func verifyObject(object:NSDictionary, attributeName:NSString, attributePattern:AnyObject, patternStack:NSMutableArray) -> Bool {

        let isOptional = self.isOptionalAttribute(attributeName)
        let name = self.strippedAttributeName(attributeName)
        if let value: AnyObject = object.objectForKey(name) {
            return self.verifyValue(value, pattern: attributePattern, permitNull: isOptional, patternStack: patternStack)
        }
        
        return isOptional
    }
  
    internal func verifyArray(array:NSArray, pattern:NSArray, patternStack:NSMutableArray) -> Bool {

        if pattern.count == 0 {
            return true // Pattern is empty array. It accepts any size of array.
        } else if array.count == 0 {
            return false //Pattern is not empty. It rejects empty array.
        }
    
        //Here, both array Pattern and array are not empty
        if let valuePattern: AnyObject? = pattern.firstObject {
            var valid = true
            
            array.enumerateObjectsUsingBlock { (value, index, stop) -> Void in
                if !self.verifyValue(value, pattern: valuePattern!, permitNull: false, patternStack: patternStack) {
                    valid = false
                    stop.memory = true
                }
            }
            return valid
        } else {
            return false
        }
    
    }
    
    internal func verifyBaseValue(value:AnyObject, pattern:String, patternStack:NSMutableArray) -> Bool {
        
        patternStack.addObject(pattern)
        
        var valid = false
        if "string" == pattern || pattern.hasPrefix("string:") {
            if let value = value as? NSString {
                valid = verifyString(value as String, pattern:pattern)
            } else {
                valid = false
            }
            
        } else if "number" == pattern || pattern.hasPrefix("number:") {
            if let value = value as? NSNumber {
                valid = verifyNumber(value, pattern: pattern)
            } else {
                valid = false
            }
            
        } else if "int" == pattern || pattern.hasPrefix("int:") {
          
            if let value = value as? NSNumber {
                if isNumberFromInt(value) {
                    valid = verifyNumber(value, pattern: pattern)
                } else {
                    valid = false
                }
                
            } else {
                valid = false
            }
            
        } else if "bool" == pattern {
            if let value = value as? NSNumber {
                valid = true
            } else {
                valid = false
            }
        } else if "url" == pattern {
            valid = verifyURL(value)
        } else if "url:http" == pattern {
            valid = verifyHTTPURL(value)
        } else if "email" == pattern {
            valid = verifyEmail(value)
        } else if "color" == pattern {
            valid = verifyColor(value)
        } else if "*" == pattern {
            valid = !(value is NSArray && value is NSDictionary)
        } else if pattern.hasPrefix("[") {
            //Multipal types. Only support basic type names. Doesn't support regular expression completely. 
            let pattern = pattern.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " \t\n\r]["))
            let types = pattern.componentsSeparatedByString("|")
            for type in types {
                valid = verifyBaseValue(value, pattern: type, patternStack: patternStack)
                if valid {break}
                
            }
            
        }
        
        if valid {
            patternStack.removeLastObject()
        }
        
        
        return valid
    }
    
    internal func isNumberFromInt(value:NSNumber) -> Bool {
        let numberType = CFNumberGetType(value)
        return numberType == CFNumberType.IntType
            || numberType == CFNumberType.ShortType
            || numberType == CFNumberType.SInt8Type
            || numberType == CFNumberType.SInt16Type
            || numberType == CFNumberType.SInt32Type
            || numberType == CFNumberType.SInt64Type
            || numberType == CFNumberType.LongType
            || numberType == CFNumberType.LongLongType
    }
    
    internal func verifyNumber(value:NSNumber, pattern: NSString) -> Bool {
    
        let components = pattern.componentsSeparatedByString(":")
        if components.count < 2 {
            return true
        }
        
        var valid = true;

        let range = (components[1] as String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let rangeValues = range.componentsSeparatedByString(",")
        if (rangeValues.count == 2) {
            
            let minStr = rangeValues[0]
            let maxStr = rangeValues[1]
            
            let min = (minStr.utf16.count == 0) ? -FLT_MIN : (minStr as NSString).floatValue
            let max = (maxStr.utf16.count == 0) ? -FLT_MAX : (maxStr as NSString).floatValue

            valid = min <= value.floatValue && max >= value.floatValue
            
        }
        
        return valid
        
        
    }
    
    
    internal func verifyString(value:String, pattern:String) -> Bool {
        let components = pattern.componentsSeparatedByString(":")
        if components.count > 1 {
            if let regexPattern = components[1] as String? {
                if let regex = try? NSRegularExpression(pattern: regexPattern, options: NSRegularExpressionOptions(rawValue: 0)) {
                    let numMatches = regex.numberOfMatchesInString(value, options: NSMatchingOptions.ReportCompletion, range: NSMakeRange(0, value.utf16.count))
                    return numMatches > 0
                }
            }
            return false
            
        } else {
            return true
        }
    }
    
    internal func verifyURL(value:AnyObject) -> Bool {
        return urlFromValue(value) != nil
    }
    
    internal func verifyHTTPURL(value:AnyObject) -> Bool {

        if let url = urlFromValue(value) {
            
            let scheme = url.scheme.lowercaseString
            let host = url.host
            return host != nil && (scheme == "http" || scheme == "https") && host!.utf16.count > 0
        } else {
            return false
        }
    }
    
    
    internal func verifyEmail(value:AnyObject) -> Bool {
        
        if let value = value as? NSString {

            let emailRegex = "[^@\\s]+@[^.@\\s]+(\\.[^.@\\s]+)+"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailTest.evaluateWithObject(value)
            
        }
            
        return false
        
    }
    
    
    internal func verifyColor(value:AnyObject) -> Bool {

        var color:UIColor?
        if let value = value as? NSString {
            
            color = colorWithHexString(value as String)
            
        } else if let value = value as? NSNumber {
            if (value.longValue >= 0 && value.longValue <= 0xFFFFFF) {
                color = colorWithInt32(value.unsignedIntValue)
            } else {
                color = nil
            }
        }
        
        return color != nil
    }
    
    internal func colorWithInt32(rgbValue: UInt32) -> UIColor? {
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let b = CGFloat((rgbValue & 0x0000FF) >> 16) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    internal func colorWithHexString(hex:String) -> UIColor? {
        var hexNumber: String = ""
        if hex.hasPrefix("0x") || hex.hasPrefix("0X") {
            hexNumber = hex.substringFromIndex(hex.startIndex.advancedBy(2))
        }
        if hexNumber.utf16.count != 6 {
            return nil
        }
        
        let rgbValue = intValueFromHex(hexNumber)
        return colorWithInt32(rgbValue)
        
    }
    
    internal func intValueFromHex(hexString:String) -> UInt32 {
        var result:UInt32 = 0
        NSScanner(string:hexString).scanHexInt(&result)
        return result
    }
    
    internal func urlFromValue(value:AnyObject) -> NSURL? {
        if  let value = value as? String {
            let value = value.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            if value.utf16.count == 0 {
                return nil
            } else {
                return NSURL(string: value)
            }
            
        } else {
            return nil
        }
        
    }
    
    
    internal func isOptionalAttribute(name:NSString) -> Bool {
        return name.hasSuffix("?")
    }
    
    internal func strippedAttributeName(name:NSString) -> NSString {
        if isOptionalAttribute(name) {
            return name.substringToIndex(name.length-1)
        } else {
            return name
        }
    }
    
    internal func buildErrorFromPatternStack(patternStack:NSArray) -> NSError {
        
        let path = buildPathFromPatternStack(patternStack)
        let localizedDescription = "Invalid pattern \(path)"
        let userInfo = [NSLocalizedDescriptionKey: localizedDescription]
        return NSError(domain: VeriJSONErrorDomain, code: VeriJSONErrorCode.InvalidPattern.rawValue, userInfo:userInfo)
        
    }
    
    internal func buildPathFromPatternStack(patternStack:NSArray) -> String {
        return patternStack.componentsJoinedByString(".")
    }
    
}