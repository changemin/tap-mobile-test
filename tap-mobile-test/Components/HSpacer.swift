//
//  HSpacer.swift
//  tap-mobile-test
//
//  Created by 변경민 on 2022/01/31.
//

import SwiftUI

struct HSpacer: View {
    @Binding var amount: CGFloat
    
    var body: some View {
        Spacer().frame(width: amount)
    }
}
