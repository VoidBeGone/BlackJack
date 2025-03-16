//
//  ContentView.swift
//  blackjack
//
//  Created by Peter Yoo on 2025-03-07.
//

import SwiftUI

struct ContentView: View {
    @State var userCards:[Int] = []
    @State var userScore = 0
    @State var dealerCards:[Int] = []
    @State var dealerScore = 0
    @State var dealersTime = false
    @State var usersTime = true
    @State var gameOver = true
    @State var winScreen = false
    var body: some View {
        
        ZStack{
            VStack{
                Image("background-cloth")
            }.padding()
        
                
            VStack {
                Text("BlackJack").font(.largeTitle).fontWeight(.bold)
                if !gameOver{
                    Text("\(dealerScore)").font(.title2).fontWeight(.bold)
                    GeometryReader { geometry in
                        HStack{
                            if dealersTime {
                                ForEach(dealerCards, id: \.self) { card in
                                    Image("card\(card)").resizable().scaledToFit().transition(.scale)
                                }
                            }
                            else{
                                Image("card\(dealerCards[0])").resizable().scaledToFit().transition(.scale)
                                Image("back").resizable().scaledToFit().transition(.scale)
                            }
                        }.frame(width: geometry.size.width * 1).animation(.default, value: dealerCards)
                    }.frame(height:100).padding()
                    
                    Button(action:{
                        if userCards.count < 5 && usersTime{
                            increaseUserScore()
                        }
                    }
                    ){Image("back")}
                    
                    GeometryReader { geometry in
                        HStack{
                            ForEach(userCards, id: \.self) { card in
                                Image("card\(card)").resizable().scaledToFit().transition(.scale)
                            }
                        }.frame(width: geometry.size.width * 1).animation(.default, value: userCards)
                    }.frame(height:100).padding()
                    
                    Button("Stay") {
                        dealersTime = true
                        usersTime = false
                        dealerTurn()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            gameOver = true
                            winScreen = true
                        }
                    }.padding().font(.largeTitle).fontWeight(.bold).foregroundColor(.black).background(Color.white).cornerRadius(40)
                    
                    Text("\(userScore)").font(.title2).fontWeight(.bold)
                }
                else if winScreen{
                    Text("Dealer Score: \(dealerScore)").font(.largeTitle).fontWeight(.bold)
                    Text("Your Score: \(userScore)").font(.largeTitle).fontWeight(.bold)
                    if didYouWin(){
                        Text("CONGRATS YOU WON").font(.largeTitle).fontWeight(.bold).foregroundColor(.green)
                    }
                    else{
                        Text("L YOU LOST").font(.largeTitle).fontWeight(.bold).foregroundColor(.red)
                    }
                    Button("Start"){
                        startGame()
                        gameOver = false
                    }.padding().font(.largeTitle).fontWeight(.bold).foregroundColor(.black).background(Color.white).cornerRadius(40)
                }
                else{
                    Button("Start"){
                        startGame()
                        gameOver = false
                    }.padding().font(.largeTitle).fontWeight(.bold).foregroundColor(.black).background(Color.white).cornerRadius(40)
                }
            }

        }
    }
    
    func increaseUserScore(){
        let newCard = randomCard()
        userCards.append(newCard)
        userScore = scoreTally(userCards)
        overScore()
    }
    func randomCard() -> Int{
        let randomNumber : Int = Int.random(in: 2...14)
        return randomNumber // can do /(var)
    }
    
    func scoreTally(_ listInsert : [Int]) ->Int{
        var count = 0
        for x in listInsert{
            if x < 14 && x >= 10{
                count += 10
            }
            else if x == 14{
                count += 1
                //need to add function for aces to determine high or low
            }
            else{
                count += x
            }
        }
        return count
    }
    
    func dealerTurn(){
        if userScore > 21 || dealerScore >= 18 || dealerScore > userScore{
            return
        }
        dealerCards.append(randomCard())
        dealerScore = scoreTally(dealerCards)
        dealerTurn()
    }
    
    func overScore(){
        if userScore > 21 || dealerScore > 21{
            usersTime = false
            dealersTime = false
        }
    }
    
    func startGame(){
        userCards = []
        dealerCards = []
        userCards.append(randomCard())
        userCards.append(randomCard())
        userScore = scoreTally(userCards)
        dealerCards.append(randomCard())
        dealerScore = scoreTally(dealerCards)
        dealersTime = false
        usersTime = true
        winScreen = false
    }
    
    func didYouWin() -> Bool{
        if userScore > 21{
            return false
        }
        else if userScore >= dealerScore || dealerScore > 21{
            return true
        }
        return false
    }
    
}


#Preview {
    ContentView()
}
