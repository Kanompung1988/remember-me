//
//  welcomeview.swift
//  remember me
//
//  Created by admin on 15/6/2567 BE.
//

struct WelcomeView: View {
    @State private var isGameStarted = false
    var body: some View {
        VStack {
            Text("Welcome to Memory Game")
                .font(.largeTitle)
                .padding()

            Button(action: {
                isGameStarted = true
            }) {
                Text("Start Game")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isGameStarted, content: {
            MemoryGameView()
        })
    }
}
