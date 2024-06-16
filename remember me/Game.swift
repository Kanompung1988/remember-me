import SwiftUI

struct Game: View {
    @Environment (\.dismiss) var dismiss
    @State private var cards: [Card] = []
    @State private var firstCardIndex: Int? = nil
    @State private var secondCardIndex: Int? = nil
    @State private var matchedCards: Set<Int> = []
    @State private var isGameOver = false
    @State private var attempts = 0
    @State private var message: String = ""
    @State private var failCount = 0
    @State private var correct = 0
    @State private var showSnakeGame: Bool = false
    @State var size = 0
    
    let images = ["1", "2", "3", "4", "5", "6"]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image("game")
                    .resizable()
                    .ignoresSafeArea()
                VStack{
                    Spacer()
                        .frame(height: 300)
                    Image("button")
                        .frame(width: 200 , height: 60)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                VStack{
                    HStack{
                        Spacer()
                        Text("Fail: \(failCount)")
                            .font(.title)
                            .foregroundColor(.red)
                            .padding(.top, 20)
                            .padding(.trailing)
                    }
                    Spacer()
                }
                if isGameOver {
                    if matchedCards.count == cards.count {
                        Text("Victory!")
                            .font(.largeTitle)
                            .padding()
                    } else {
                        Text("Game Over")
                            .font(.largeTitle)
                            .padding()
                    }
                    Image("snake")
                        .resizable()
                        .ignoresSafeArea()
                    VStack{
                        Text("Victory!")
                            .font(.title)
                        Text("Attempts: \(attempts)")
                            .font(.title)
                            .padding()
                        Button(action: startGame) {
                            Text("Play Again")
                                .font(.title)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                } else {
                    VStack{
                        LazyVGrid(columns: Array(repeating: GridItem(), count: 4), spacing: 5) {
                            ForEach(cards.indices, id: \.self) { index in
                                CardView(card: cards[index], isFaceUp: matchedCards.contains(index) || index == firstCardIndex || index == secondCardIndex)
                                    .onTapGesture {
                                        handleTap(on: index)
                                    }
                            }
                        }
                        .padding()
                        Text(message)
                            .font(.title)
                            .foregroundColor(message == "Fail" ? .white : .white)
                            .padding()
                    }
                }
            }
            .onAppear {
                startGame()
            }
            .navigationDestination(isPresented: $showSnakeGame) {
                snakkk(size: $size)
                .navigationBarBackButtonHidden()
            }
        }
        
    }
    
    func startGame() {
        var newCards: [Card] = []
        for image in images {
            newCards.append(Card(imageName: image))
            newCards.append(Card(imageName: image))
        }
        newCards.shuffle()
        cards = newCards
        firstCardIndex = nil
        secondCardIndex = nil
        matchedCards = []
        isGameOver = false
        attempts = 0
        message = ""
    }
    
    func handleTap(on index: Int) {
        if matchedCards.contains(index) || index == firstCardIndex {
            return
        }
        
        if firstCardIndex == nil {
            firstCardIndex = index
        } else if secondCardIndex == nil {
            secondCardIndex = index
            attempts += 1
            if cards[firstCardIndex!].imageName == cards[secondCardIndex!].imageName {
                matchedCards.insert(firstCardIndex!)
                matchedCards.insert(secondCardIndex!)
                resetSelections()
                message = "Correct"
                if matchedCards.count == cards.count {
                    isGameOver = true
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    resetSelections()
                    message = "Fail"
                    if message == "Fail" {
                        failCount += 1
                        if failCount == 2 { // เช็คว่าครบ 2 ครั้งแล้วหรือไม่
                            showSnakeGame.toggle()
                            if size == 1 {
                                dismiss()
                            }else {
                                        failCount = 0
                                        startGame()
                                    }
                        }
                    }
                }
            }
        }
    }
    
    func resetSelections() {
        firstCardIndex = nil
        secondCardIndex = nil
    }
    
    struct Card: Identifiable {
        let id = UUID()
        let imageName: String
    }
    
    struct CardView: View {
        let card: Card
        var isFaceUp: Bool
        
        var body: some View {
            ZStack {
                if isFaceUp {
                    Image(card.imageName)
                        .resizable()
                        .scaledToFit()
                } else {
                    Rectangle()
                        .fill(Color.white)
                }
            }
            .frame(width: 80, height: 80)
        }
    }
    
    @main
    struct MemoryGameApp: App {
        var body: some Scene {
            WindowGroup {
                ContentView()
            }
        }
    }
}

#Preview {
    ContentView()
}

