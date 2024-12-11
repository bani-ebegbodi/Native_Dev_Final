//
//  MemoryMatch.swift
//  FinalProject
//
//  Created by Banibe Ebegbodi on 12/3/24.
//

import SwiftUI

struct MemoryCard: Identifiable {
    let id = UUID()
    let imageName: String
    var isFaceUp: Bool = false
    var isMatched: Bool = false
}

class MemoryGameModel: ObservableObject {
    @Published var cards: [MemoryCard] = []
    @Published var firstFlippedCardIndex: Int? = nil
    
    init() {
        setupGame()
    }
    
    func setupGame() {
        let images = ["🎄", "🎅", "❄️", "🔔", "🎁", "⛄️"]
        let pairedImages = (images + images).shuffled()
        
        cards = pairedImages.map { MemoryCard(imageName: $0) }
    }
    
    //reseting game
    func resetGame() {
            setupGame()
            firstFlippedCardIndex = nil
        }
    
    //finding if game is won
    var isGameWon: Bool {
        cards.allSatisfy { $0.isMatched }
    }
    
    //flipping cards
    func flipCard(at index: Int) {
        if cards[index].isFaceUp || cards[index].isMatched {
            return
        }
        
        cards[index].isFaceUp = true
        
        if let firstIndex = firstFlippedCardIndex {
            //second card flipped
            checkForMatch(firstIndex: firstIndex, secondIndex: index)
            firstFlippedCardIndex = nil
        } else {
            //first card flipped
            firstFlippedCardIndex = index
        }
    }
    
    //checking for matches
    private func checkForMatch(firstIndex: Int, secondIndex: Int) {
        if cards[firstIndex].imageName == cards[secondIndex].imageName {
            cards[firstIndex].isMatched = true
            cards[secondIndex].isMatched = true
        } else {
            //flip back after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.cards[firstIndex].isFaceUp = false
                self.cards[secondIndex].isFaceUp = false
            }
        }
    }
}


struct MemoryMatch: View {
    
    @StateObject private var memoryModel = MemoryGameModel()
        
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
    var body: some View {
        ZStack {
            Color.teal
                .ignoresSafeArea()
            ForEach(0..<10) { _ in
                SnowfallEffect()
            }
            
            VStack {
                Text("Christmas")
                    .font(.system(size: 45, weight: .heavy, design: .rounded))
                    .padding(.horizontal)
                    .foregroundColor(.white)
                
                Text("Memory Match")
                    .font(.system(size: 45, weight: .heavy, design: .rounded))
                    .padding(.horizontal)
                    .foregroundColor(.white)
                
                //you won!
                if memoryModel.isGameWon {
                    Text("You won the game!")
                        .frame(width: 350, height: 40)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .background(.darkGreen)
                        .clipShape(.capsule)
                        .padding()
                }
                
                //cards laid out
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(memoryModel.cards) { card in
                        CardView(card: card)
                            .onTapGesture {
                                if let index = memoryModel.cards.firstIndex(where: { $0.id == card.id }) {
                                    memoryModel.flipCard(at: index)
                                }
                            }
                    }
                }
                .padding()
                
                //reseting game button
                Button(action: {
                    memoryModel.resetGame()
                }) {
                    Text("RESET GAME")
                        .frame(width: 300, height: 50)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .clipShape(.capsule)
                }
                .padding()
            }
        }
    }
}

//card look
struct CardView: View {
    let card: MemoryCard
    
    var body: some View {
        ZStack {
            if card.isFaceUp || card.isMatched {
                Text(card.imageName)
                    .font(.largeTitle)
                    .frame(width: 60, height: 80)
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 3)
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.blue)
                    .frame(width: 60, height: 80)

            }
        }
        .animation(.easeInOut, value: card.isFaceUp)
    }
}


#Preview {
    MemoryMatch()
}
