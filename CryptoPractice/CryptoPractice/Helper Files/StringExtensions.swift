//
//  StringExtensions.swift
//  CryptoPractice
//
//  Created by Austin Vesich on 5/28/23.
//

import Foundation

extension String {
    func roundAsDouble(to: Int) -> String {
        return String(format:"%.\(to)f", Double(self) ?? 0.0)
    }
    
    func toDouble() -> Double {
        return Double(self) ?? 0.0
    }
}
