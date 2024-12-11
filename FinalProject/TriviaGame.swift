//
//  TriviaGame.swift
//  FinalProject
//
//  Created by Banibe Ebegbodi on 12/5/24.
//

import SwiftUI

struct TriviaQuestion {
    let question: String
    let options: [String]
    let correctAnswer: String
}

class TriviaGameModel: ObservableObject {
    @Published var questions: [TriviaQuestion] = []
    @Published var currentQuestionIndex: Int = 0
    @Published var score: Int = 0
    @Published var showResult: Bool = false
    @Published var isGameOver: Bool = false
    
    init() {
        loadQuestions()
    }
    
    //couldn't find christmas trivia api so just made up a few questions instead
    func loadQuestions() {
        questions = [
            TriviaQuestion(question: "What is Frosty the Snowman's nose made of?", options: ["A carrot", "A rock", "A button", "A stick"], correctAnswer: "A button"),
            TriviaQuestion(question: "What do people traditionally put on top of a Christmas tree?", options: ["Star", "Bow", "Santa", "Angel"], correctAnswer: "Angel"),
            TriviaQuestion(question: "Which country started the tradition of putting up a Christmas tree?", options: ["Germany", "USA", "France", "Canada"], correctAnswer: "Germany"),
            TriviaQuestion(question: "How many reindeer pull Santa's sleigh?", options: ["8", "9", "10", "7"], correctAnswer: "9"),
            TriviaQuestion(question: "What popular Christmas song was originally written for Thanksgiving?", options: ["Deck the Halls", "Jingle Bells", "Silent Night", "O Christmas Tree"], correctAnswer: "Jingle Bells")
        ].shuffled()
    }
    
    func checkAnswer(_ answer: String) {
        if questions[currentQuestionIndex].correctAnswer == answer {
            score += 1
        }
        
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
        } else {
            isGameOver = true
        }
    }
}

struct TriviaGame: View {
    @StateObject private var triviaModel = TriviaGameModel()
    
    var body: some View {
        ZStack {
            Color.teal
                .ignoresSafeArea()
            ForEach(0..<10) { _ in
                SnowfallEffect()
            }
            VStack {
                //ending card
                if triviaModel.isGameOver {
                    VStack {
                        Text("Game Over!")
                            .font(.system(size: 40, design: .rounded))
                            .padding()
                            .foregroundColor(.white)
                        Text("Your Score: \(triviaModel.score) / \(triviaModel.questions.count)")
                            .font(.system(size: 30, design: .rounded))
                            .padding()
                            .foregroundColor(.white)
                        Button(action: {
                            triviaModel.loadQuestions()
                            triviaModel.currentQuestionIndex = 0
                            triviaModel.score = 0
                            triviaModel.isGameOver = false
                        }) {
                            Text("Play Again")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .font(.system(size: 25, weight: .heavy, design: .rounded))
                            .clipShape(.capsule)                    }
                    }
                } else {
                    VStack {
                        Text("Christmas")
                            .font(.system(size: 45, weight: .heavy, design: .rounded))
                            .padding(.horizontal)
                            .foregroundColor(.white)
                        
                        Text("Trivia")
                            .font(.system(size: 45, weight: .heavy, design: .rounded))
                            .padding(.bottom)
                            .foregroundColor(.white)
                        
                        //a progress bar
                        HStack(spacing: 10) {
                            ForEach(0..<triviaModel.questions.count, id: \.self) { index in
                                Circle()
                                    .fill(index <= triviaModel.currentQuestionIndex ? Color.blue : Color.gray)
                                    .frame(width: 15, height: 15)
                            }
                        }
                        .padding()
                        
                        //questions and answer display
                        Text(triviaModel.questions[triviaModel.currentQuestionIndex].question)
                            .font(.system(size: 25, design: .rounded))
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(.white)
                        
                        ForEach(triviaModel.questions[triviaModel.currentQuestionIndex].options, id: \.self) { option in
                            Button(action: {
                                triviaModel.checkAnswer(option)
                            }) {
                                Text(option)
                                    .font(.system(size: 25, design: .rounded))
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding()
        }
    }
}


#Preview {
    TriviaGame()
}
