//
//  ChristmasLights.swift
//  FinalProject
//
//  Created by Banibe Ebegbodi on 12/6/24.
//


//I wanted a 4th game, so I asked ChatGPT about a simple game and it suggested a light sequence game
import SwiftUI

struct ChristmasLights: View {
    @State private var lightSequence: [Int] = []  // Stores the correct sequence
    @State private var playerSequence: [Int] = []  // Stores the player's taps
    @State private var currentStep: Int? = nil  // Tracks the current step in the sequence
    @State private var isShowingSequence = false  // Determines if the sequence is being shown
    @State private var gameOver = false  // Tracks if the game has ended
    @State private var level = 1  // Tracks the current level
    
    
    //I mainly worked on the naming convention and the look of the game
    let lights = [Color.red, Color.darkGreen, Color.blue, Color.yellow]
    
    var body: some View {
        ZStack {
            Color.teal
                .ignoresSafeArea()
            //didn't add snow effect here because it did a weird glitch and it might have been too distracting

            VStack {
                if gameOver {
                    VStack {
                        Text("Game Over!")
                            .font(.system(size: 40, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                        Text("You reached level \(level)")
                            .font(.system(size: 30, design: .rounded))
                            .padding()
                            .foregroundColor(.white)
                        Button(action: resetGame) {
                            Text("Play Again")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .font(.system(size: 25, weight: .heavy, design: .rounded))
                                .clipShape(.capsule)
                        }
                    }
                } else {
                    Text("Christmas")
                        .font(.system(size: 45, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Lights Sequence")
                        .font(.system(size: 45, weight: .heavy, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("Level \(level)")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    
                    HStack(spacing: 20) {
                        ForEach(0..<lights.count, id: \.self) { index in
                            Circle()
                                .fill(lights[index])
                                .frame(width: 70, height: 70)
                                .overlay(
                                    Circle()
                                        .stroke(currentStep == index ? Color.white : Color.clear, lineWidth: 5)
                                )
                                .onTapGesture {
                                    if !isShowingSequence {
                                        playerTapped(index)
                                    }
                                }
                        }
                    }
                    .padding()
                    
                    if isShowingSequence {
                        Text("Watch the lights!")
                            .frame(width: 300, height: 50)
                            .background(.red)
                            .foregroundStyle(.white)
                            .font(.system(size: 30, weight: .heavy, design: .rounded))
                            .clipShape(.capsule)
                    }
                }
            }
            .onAppear(perform: startGame)
            .padding()
        }
    }
    
    //I started out with the function set up of the game, but ChatGPT helped the most on the showSequence() function and adding a new light
    
    func startGame() {
        resetGame()
    }
    
    func resetGame() {
        level = 1
        lightSequence = []
        playerSequence = []
        gameOver = false
        addNewLight()
    }
    
    func addNewLight() {
        playerSequence = []
        lightSequence.append(Int.random(in: 0..<lights.count))
        showSequence()
    }
    
    func showSequence() {
        isShowingSequence = true
        currentStep = nil

        // Add an initial delay to allow users to read the "Watch the lights!" message
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Adjust the duration as needed
            for (index, light) in lightSequence.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.8) {
                    currentStep = light

                    // Clear the highlight after a short delay
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        currentStep = nil

                        // End the sequence display if it's the last step
                        if index == self.lightSequence.count - 1 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                self.isShowingSequence = false
                            }
                        }
                    }
                }
            }
        }
    }
    
    func playerTapped(_ index: Int) {
        playerSequence.append(index)
        
        if playerSequence[playerSequence.count - 1] != lightSequence[playerSequence.count - 1] {
            gameOver = true
        } else if playerSequence.count == lightSequence.count {
            level += 1
            addNewLight()
        }
    }
}


#Preview {
    ChristmasLights()
}
