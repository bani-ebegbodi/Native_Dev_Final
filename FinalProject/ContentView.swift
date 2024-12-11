//
//  ContentView.swift
//  FinalProject
//
//  Created by Banibe Ebegbodi on 11/22/24.
//

import SwiftUI

struct ContentView: View {
    //timer things
    @State private var timeRemaining = calculateTimeUntilChristmas()
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeRemaining = calculateTimeUntilChristmas()
        }
    }
    
    //animating banner things
    @State private var textOffset: CGFloat = UIScreen.main.bounds.width
    
    //tictactoe state so game doesn't reset
    @StateObject private var ticTacModal = TicTacModal()
    
    func animateBanner() {
            withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
                textOffset = -UIScreen.main.bounds.width
            }
        }
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    //title w/bg
                    ZStack {
                        Image("christmasbg")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                        VStack {
                            Text("Christmas")
                                .font(.system(size: 55, weight: .bold, design: .rounded))
                                .foregroundStyle(.white)
                                .shadow(color: .black, radius: 2, x: 6, y: 4)
                            Text("Mini Games")
                                .font(.system(size: 35, weight: .semibold, design: .rounded))
                                .foregroundStyle(.white)
                                .shadow(color: .black, radius: 2, x: 6, y: 4)
                        }
                        .padding()
                    }
                    
                    //banner
                    ZStack {
                        Color.darkGreen
                        Text("🎄Countdown Christmas with fun mini games!🔔")
                            .font(.headline)
                            .foregroundColor(.white)
                            .offset(x: textOffset)
                            .onAppear {
                                animateBanner()
                            }
                    }
                    .frame(height: 40)
                    .padding(.bottom, 10)
                    
                    //Spacer()
                    
                    //countdown timer
                    HStack(spacing: 28) {
                        CounterBox(label: "Days", value: timeRemaining.days)
                        CounterBox(label: "Hours", value: timeRemaining.hours)
                        CounterBox(label: "Mins", value: timeRemaining.minutes)
                        CounterBox(label: "Secs", value: timeRemaining.seconds)
                    }
                    .onAppear {
                        startTimer()
                    }
                    .padding(.bottom)
                    
                    //games
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            GameCard(title: "Tic-Tac-Toe", image: "2", destination: AnyView(TicTacToe(TicTac: ticTacModal)))
                            GameCard(title: "Memory Match", image: "3", destination: AnyView(MemoryMatch()))
                            GameCard(title: "Trivia Game", image: "1", destination: AnyView(TriviaGame()))
                            GameCard(title: "Light Sequence", image: "4", destination: AnyView(ChristmasLights()))
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
            }
        }

    }
}

//counter
struct CounterBox: View {
    let label: String
    let value: Int
    
    var body: some View {
        VStack {
            Text(label)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(.black)
            
            Text("\(value)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(width: 60, height: 60)
                .background(Color.yellow)
                .cornerRadius(10)
        }
        
    }
}

struct TimeRemaining {
    let days: Int
    let hours: Int
    let minutes: Int
    let seconds: Int
}

func calculateTimeUntilChristmas() -> TimeRemaining {
    let calendar = Calendar.current
    let currentDate = Date()
    let christmasDate = calendar.date(from: DateComponents(year: calendar.component(.year, from: currentDate), month: 12, day: 25))!
    
    let difference = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: christmasDate)
    return TimeRemaining(
        days: difference.day ?? 0,
        hours: difference.hour ?? 0,
        minutes: difference.minute ?? 0,
        seconds: difference.second ?? 0
    )
}

//games
struct GameCard: View {
    let title: String
    let image: String
    let destination: AnyView
    
    var body: some View {
        NavigationLink(destination: destination) {
            VStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 100)
                    .cornerRadius(10)
                Text(title)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            .padding()
            .background(.black)
            .cornerRadius(10)
            .shadow(radius: 3)
        }
    }
}



#Preview {
    ContentView()
}
