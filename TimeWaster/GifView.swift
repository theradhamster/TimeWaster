//
//  GifView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/5/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct GifView: View {
    @State var isAnimating = true
    
    var body: some View {
        ZStack {
            AnimatedImage(name: "saulgoodman.gif", isAnimating: $isAnimating)
        }
    }
}

#Preview {
    GifView()
}
