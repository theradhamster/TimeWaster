//
//  TestView.swift
//  TimeWaster
//
//  Created by Dorothy Luetz on 11/10/23.
//

import SwiftUI

struct TestView: View {
    @State private var username = ""
    @State private var text = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
            TextField("Post", text: $text)
            Button("Post") {
                let newPost = Post(username: username, text: text)
                Task {
                    do {
                        try await CloudKitService.save(newPost)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    TestView()
}
