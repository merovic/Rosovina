//
//  SwiftUIExt.swift
//  Hareef
//
//  Created by PaySky106 on 09/06/2023.
//

import Foundation
import SwiftUI
import Combine

extension View {
    
    /// A backwards compatible wrapper for iOS 14 onChange`
    @ViewBuilder
    func valueChanged<T: Equatable>(of value: T, perform onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, *) {
            self.onChange(of: value, perform: onChange)
        }
    }
}
