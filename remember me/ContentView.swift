//
//  SwiftUIView.swift
//  remember me
//
//  Created by admin on 15/6/2567 BE.
//

import SwiftUI

struct ContentView: View {
    @State var isGameStarted = false
    var body: some View {
        ZStack {
            Image("Start")
                .resizable()
                .ignoresSafeArea()
            VStack {
                Spacer()
                    .frame(height: 300)
                Button(action: {
                    isGameStarted = true
                }) {
                    ZStack{
                        Image("button")
                            .frame(width: 200 , height: 60)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        Text("Start Game")
                            .foregroundColor(.white)
                            .font(.title)
                            .padding()
                    }
                }
                .padding()
            }
        }
        .fullScreenCover(isPresented: $isGameStarted, content: {
            Game()

        })
    }
}

#Preview {
    ContentView()
}


