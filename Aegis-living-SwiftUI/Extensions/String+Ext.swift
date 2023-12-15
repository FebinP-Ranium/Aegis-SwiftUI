//
//  Color+Ext.swift
//  Appetizer-SwiftUI
//
//  Created by Febin Puthalath on 12/12/23.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let emailFormat         = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate      = NSPredicate(format: "SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: self)
    }
   
        func capitalizingFirstLetter() -> String {
            return prefix(1).capitalized + dropFirst()
        }
    
}
