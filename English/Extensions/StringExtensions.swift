//
//  StringExtensions.swift
//  English
//
//  Created by TaiTau on 08/04/2023.
//

import Foundation
import UIKit
//MARK: Standard
extension String {
    func defaultValue(_ value: String = "") -> String {
        if(self.isEmpty) {
            return value;
        }
        return self;
    }
    
    func trim() -> String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    
    func changeFormatTime() -> String {
        let listString = self.split(separator: " ")
        let dateString = listString[0]
        let listDate = dateString.split(separator: "-")
        let year = listDate[0]
        let month = listDate[1]
        let day = listDate[2]
        return "\(day)/\(month)/\(year) \(listString[1])"
    }
    
    func isVNCharacter() -> Bool {
        return matches("^[a-zA-Z]+$")
    }
    func isContainsSpecialCharacter() -> Bool {
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9_-].*", options: [])
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) != nil
    }

    
    func convertToUnsign() -> String {
        var value: String = self.folding(options: .diacriticInsensitive,locale: Locale(identifier: "en-EN")).lowercased()
        value = value.replace(target: "đ", withString: "d")
        return value
    }
    
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()

        return label.frame.height
     }
}

//MARK: Number
extension String {
    func isNumber() -> Bool {
        return matches("^[0-9]+$");
    }
    
    func isNumber(limit: Int) -> Bool {
        return matches("^(^[0-9]{0,\(limit)})$");
    }
    
    func isDecimal(integralPart: Int, fractionalPart: Int) -> Bool{
        let value = self.replace(target: ",", withString: "")
        return value.matches("^(^[0-9]{0,\(integralPart)})*(\\.[0-9]{0,\(fractionalPart)})?$");
    }
    
    func rawNumber() -> String {
        return self.replace(target: ",", withString: "").replace(target: ".", withString: "");
    }
    
    func toNumber() -> NSNumber {
        let value = self.replace(target: ",", withString: "")
        return NSNumber(value: Double(value) ?? 0);
    }
    
//    func formatSystemNumber() -> String {
//
//        var value = self.replace(target: ",", withString: "")
//        value = Utility.convertString(toNewFormatBCT: value)
//        return value.isEmpty ? "0" : value;
//    }
    
//    func formatInputFractionNumber() -> String {
//
//        var value = self
//        value = Utility.convertString(toNewFormatBCT: value)
//        return value.isEmpty ? "0" : value;
//    }
        
    func toFloatNumber() -> NSNumber {
        return NSNumber(value: Double(self) ?? 0)
    }
}

//MARK: My App
extension String {
    
    /**
     @Purpose: returns a string that has been unsigned, whitespaced, and capitalized.
     **/
    func stringFilter() -> String {
        return self.uppercased().trim().convertToUnsign();
    }
    
}

//MARK: Date
extension String {
    func toDate(_ format: String = "dd/MM/yyyy") -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "vi_VN")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let value = self.replace(target: ".0", withString: "")
        if let date = dateFormatter.date(from: value) {
            return date
        }
        
//        dateFormatter.dateFormat = DCMDateFormatter.dateTimeOfServer.rawValue;
//        if let date = dateFormatter.date(from: value)  {
//            return date
//        }
//
//        dateFormatter.dateFormat = DCMDateFormatter.dateOfServer.rawValue;
//        if let date = dateFormatter.date(from: value)  {
//            return date
//        }
//
//        dateFormatter.dateFormat = DCMDateFormatter.dateTimeVN.rawValue;
//        if let date = dateFormatter.date(from: value)  {
//            return date
//        }
//
//        dateFormatter.dateFormat = DCMDateFormatter.dateVN.rawValue;
//        if let date = dateFormatter.date(from: value)  {
//            return date
//        }
        
        return nil;
    }
    
//    func toDateServer() -> String? {
//        let value = self.toDate()?.toString(format: DCMDateFormatter.dateTimeOfServer.rawValue);
//        return value;
//    }
//
//    func toDateVN() -> String? {
//        let value = self.toDate()?.toString(format: DCMDateFormatter.dateVN.rawValue);
//        return value;
//    }
}

