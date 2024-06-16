import SwiftUI

struct snakkk: View {
    @State private var Showpickgame : Bool = false
    @State private var snake: [CGPoint] = [CGPoint(x: 0, y: 0)]
    @State private var foodPosition: CGPoint = CGPoint(x: 4, y: 4)
    @State private var direction: CGPoint = CGPoint(x: 1, y: 0)
    @State private var gameTimer: Timer?
    @State private var isGameOver = false
    let snakeSize: CGFloat = 20
    let gridSize: CGFloat = 20
    @Binding var size: Int

    var body: some View {
        NavigationView { // เพิ่ม NavigationView
            VStack {
                if isGameOver {
                    ZStack{                        
                        Image("replay")
                            .resizable()
                            .ignoresSafeArea()
                        VStack{
                            Spacer()
                                .frame(height: 200)
                    NavigationLink(destination: ContentView().navigationBarBackButtonHidden(), isActive: $isGameOver)
                            {
                                ZStack{
                                    Image("button")
                                        .frame(width: 200 , height: 60)
                                        .background(Color.red)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                    Text("Play Again")
                                        .font(.title)
                                        .padding()
                                        .foregroundColor(.white)
                                   
                                }
                            }
                        }
                    }
                } else {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(width: gridSize * 20, height: gridSize * 20)

                        ForEach(0..<snake.count, id: \.self) { index in
                            Rectangle()
                                .foregroundColor(.green)
                                .frame(width: snakeSize, height: snakeSize)
                                .position(x: snake[index].x * snakeSize + snakeSize / 2,
                                          y: snake[index].y * snakeSize + snakeSize / 2)
                        }

                        Rectangle()
                            .foregroundColor(.red)
                            .frame(width: snakeSize, height: snakeSize)
                            .position(x: foodPosition.x * snakeSize + snakeSize / 2,
                                      y: foodPosition.y * snakeSize + snakeSize / 2)
                    }
                    .onAppear {
                        startGamesankk()
                    }
                }
            }
        }
    }


    func startGamesankk() {
        snake = [CGPoint(x: 0, y: 0)]
        foodPosition = CGPoint(x: Int.random(in: 0..<20), y: Int.random(in: 0..<20))
        direction = CGPoint(x: 1, y: 0)
        isGameOver = false

        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            moveSnake()
        }
    }

    func moveSnake() {
        var newHead = snake[0]
        newHead.x += direction.x
        newHead.y += direction.y

        if newHead.x < 0 || newHead.x >= 20 || newHead.y < 0 || newHead.y >= 20 || snake.contains(newHead) {
            gameOver()
            return
        }

        snake.insert(newHead, at: 0)

        if newHead == foodPosition {
            foodPosition = CGPoint(x: Int.random(in: 0..<20), y: Int.random(in: 0..<20))
            size += 1
        } else {
            snake.removeLast()
        }
    }

    func gameOver() {
        gameTimer?.invalidate()
        isGameOver = true
    }
}

struct snakkk_Previews: PreviewProvider {
    static var previews: some View {
        snakkk(size: .constant(0))
    }
}

