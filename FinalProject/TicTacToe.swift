//
//  TicTacToe.swift
//  FinalProject
//
//  Created by Banibe Ebegbodi on 11/26/24.
//

import SwiftUI

struct TicTacToe: View {
    @ObservedObject var TicTac = TicTacModal()
    var body: some View {
        ZStack {
            Color.teal
                .ignoresSafeArea()
            ForEach(0..<10) { _ in
                SnowfallEffect()
            }

            VStack {
                Text("TIC-TAC-TOE")
                    .font(.system(size: 45, weight: .heavy, design: .rounded))
                    .padding(.horizontal)
                    .foregroundColor(.white)

                
                //displaying winner
                if let winner = TicTac.winner {
                    Text("\(winner == .X ? "X" : "O") has won the game!")
                        .frame(width: 350, height: 40)
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.white)
                        .background(.darkGreen)
                        .clipShape(.capsule)
                        .padding()
                }
                
                //making the columns/game layout
                let col = Array(repeating: GridItem(.flexible()), count: 3)
                
                LazyVGrid(columns: col, content: {
                    ForEach(0..<9) { i in
                        Button(action: {
                            TicTac.buttonTap(i: i)
                        }, label: {
                            Text(TicTac.buttonLabel(i: i))
                                .frame(width: 100, height: 100)
                                .background(.blue)
                                .cornerRadius(10)
                                .foregroundStyle(.white)
                                .font(.system(size: 45, weight: .heavy))
                        })
                    }
                })
                .padding()
                
                //reset button
                Button(action: {
                    TicTac.resetGame()
                }, label: {
                    Text("RESET GAME")
                        .frame(width: 300, height: 50)
                        .background(.blue)
                        .foregroundStyle(.white)
                        .font(.system(size: 30, weight: .heavy, design: .rounded))
                        .clipShape(.capsule)
                })
                
            }
        }
    }
}

//game logic
enum Player {
    case X
    case O
}

class TicTacModal:ObservableObject {
    @Published var board: [Player?] = Array(repeating: nil, count: 9)
    @Published var activePlayer: Player = .X
    @Published var winner: Player? = nil
    
    //button tapped
    func buttonTap(i: Int) {
        
        guard board[i] == nil && winner == nil else {
            return
        }
        
        board[i] = activePlayer
        
        if checkWinner() {
            winner = activePlayer
            //Text("\(activePlayer) has won the game!")
        } else {
            activePlayer = (activePlayer == .X) ? .O : .X
        }
        
    }
    
    //label of button
    func buttonLabel(i: Int) -> String {
        if let player = board[i] {
            return player == .X ? "X" : "O"
        }
        return ""
    }
    
    //reset game
    func resetGame() {
        board = Array(repeating: nil, count: 9)
        activePlayer = .X
        winner = nil
    }
    
    //winner
    func checkWinner() -> Bool {
        //rows
        for i in stride(from: 0, to: 9, by: 3) {
            if board[i] == activePlayer && board[i + 1] == activePlayer && board[i + 2] == activePlayer {
                return true
            }
        }
        
        //columns
        for i in 0..<3 {
            if board[i] == activePlayer && board[i + 3] == activePlayer && board[i + 6] == activePlayer {
                return true
            }
        }
        
        //diagnols
        if board[0] == activePlayer && board[4] == activePlayer && board[8] == activePlayer {
            return true
        }
        
        if board[2] == activePlayer && board[4] == activePlayer && board[6] == activePlayer {
            return true
        }
        
        return false
    }
}

#Preview {
    TicTacToe()
}
