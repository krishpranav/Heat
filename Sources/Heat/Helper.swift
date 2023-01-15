//
//  File.swift
//
//
//  Created by KrisnaPranav on 15/01/23.
//

import Foundation

public extension Heat {
    /**
      @ Helper
     */
    struct Helper {
      
        public static func appendURL(_ appending: String, to baseURL: String?) -> String {
            if let base = baseURL {
                let sep = "/"
                if base.hasSuffix(sep) {
                    if appending.hasPrefix(sep) {
                        return base + appending
                    }
                    return base + appending
                }
            }
        }
        
    }
}
