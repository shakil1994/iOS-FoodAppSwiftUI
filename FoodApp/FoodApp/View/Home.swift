//
//  Home.swift
//  FoodApp
//
//  Created by Md Shah Alam on 10/15/21.
//

import SwiftUI

struct Home: View {
    
    @StateObject var HomeModel = HomeViewModel()
    
    var body: some View {
        ZStack{
            VStack(spacing: 10){
                HStack(spacing: 15){
                    Button(action: {
                        withAnimation(.easeIn){
                            HomeModel.showMenu.toggle()
                        }
                    }, label: {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .foregroundColor(Color.pink)
                    })
                    
                    Text(HomeModel.userLocation == nil ? "Locating..." : "Deliver To")
                        .foregroundColor(.black)
                    
                    Text(HomeModel.userAddress)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(Color.pink)
                    Spacer(minLength: 0)
                }.padding([.horizontal, .top])
                
                Divider()
                
                HStack(spacing: 15){
                    TextField("Search", text: $HomeModel.search)
                    
                    if HomeModel.search != "" {
                        Button(action: {}
                               , label: {
                            Image(systemName: "magnifyingglass")
                                .font(.title2)
                                .foregroundColor(.gray)
                               }).animation(.easeIn)
                    }
                }.padding(.horizontal)
                .padding(.top, 10)
                
                Divider()
                
                Spacer()
                
            }
            
            //Side Menu...
            HStack{
                Menu(homeData: HomeModel)
                    //Move Effect From Left
                    .offset(x: HomeModel.showMenu ? 0 : -UIScreen.main.bounds.width / 1.6)
                Spacer(minLength: 0)
            }
            .background(Color.black.opacity(HomeModel.showMenu ? 0.3 : 0).ignoresSafeArea()
                            //Cloasing when taps on outside...
                            .onTapGesture(perform: {
                                withAnimation(.easeIn){
                                    HomeModel.showMenu.toggle()}
                            }))
            
            
            //Non Closable alert if permission denied...
            if HomeModel.noLocation{
                Text("Please Enable Location Access In Settings To Further Move On!!!")
                    .foregroundColor(.black)
                    .frame(width: UIScreen.main.bounds.width - 100, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
        }
        .onAppear(perform: {
            //Calling location delegate...
            HomeModel.locationManager.delegate = HomeModel
            
        })
    }
}
