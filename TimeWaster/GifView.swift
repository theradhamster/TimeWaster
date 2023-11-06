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
            VStack {
                AnimatedImage(name: "gorillaspeen.gif", isAnimating: $isAnimating)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130)
                Spacer()
                AnimatedImage(name: "thinkingemoji.gif", isAnimating: $isAnimating)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80)
            }
        }
    }
}

#Preview {
    GifView()
}
