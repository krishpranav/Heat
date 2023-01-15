//
//  File.swift
//
//
//  Created by KrisnaPranav on 15/01/23.
//

import Foundation

public extension Heat {

    struct Helper {
        
        public static func appendURL(_ appending: String, to baseURL: String?) -> String {
            if let base = baseURL {
                let sep = "/"
                if base.hasSuffix(sep) {
                    if appending.hasPrefix(sep) {
                        return base + appending[appending.index(appending.startIndex, offsetBy: 1)..<appending.endIndex]
                  }
                    return base + appending
                }
                
                if appending.hasPrefix(sep) {
                    return base + appending
                }
                return base + sep + appending
            }
            return appending
        }
        
        public static func buildParams(_ parameters: [String: Any]) -> String {
            var components: [(String, String)] = []
            for key in Array(parameters.keys).sorted(by: <) {
                let value = parameters[key]
                components += Heat.Helper.queryComponents(key, value ?? "value_is_nil")
            }
            
            return components.map{"\($0)=\($1)"}.joined(separator: "&")
        }
        
        public static func queryComponents(_ key: String, _ value: Any) -> [(String, String)] {
            var components: [(String, String)] = []
            var valueString = ""
            
            switch value {
            case _ as String:
                valueString = value as! String
            case _ as Bool:
                valueString = (value as! Bool).description
            case _ as Double:
                valueString = (value as! Double).description
            case _ as Int:
                valueString = (value as! Int).description
            default:
                break
            }
            
            components.append(contentsOf: [(Heat.Helper.escape(key), Heat.Helper.escape(valueString))])
            return components
        }
        
        public static func escape(_ string: String) -> String {
            if #available(iOS 10.0, macOS 10.12, *) {
                if let esc = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                    return esc
                }
                return string
            } else {
                let chars = ":&=;+!@#$()',*"
                let legalURLCharactersToBeEscaped: CFString = chars as CFString
                return CFURLCreateStringByAddingPercentEscapes(nil, string as CFString?, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
            }
        }
    }
}

public extension String {
    var base64: String? {
        if let utf8EncodeData = self.data(using: String.Encoding.utf8, allowLossyConversion: true) {
            let base64EncodingData = utf8EncodeData.base64EncodedString(options: [])
            return base64EncodingData
        }
        return nil
    }
}

public extension String {
    
    var unicodeCharactersDecodedString: String? {
        let tempString = self.replacingOccurrences(of: "\\u", with: "\\U").replacingOccurrences(of:"\"", with: "\\\"")
        if let tempData = "\"\(tempString)\"".data(using: .utf8) {
            if let res = try? PropertyListSerialization.propertyList(from: tempData, options: [], format: nil) {
                return res as? String
            }
        }
        return nil
    }
}

public extension String {
    var data: Data {
        return self.data(using: String.Encoding.utf8)!
    }
}

public extension Dictionary {
    var pretty: String {
        return "\(self as NSDictionary)"
    }
}

public extension Array {
    var pretty: String {
        return "\(self as NSArray)"
    }
}
