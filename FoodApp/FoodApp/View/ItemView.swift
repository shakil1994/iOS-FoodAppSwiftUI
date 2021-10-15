//
//  ItemView.swift
//  FoodApp
//
//  Created by Md Shah Alam on 10/15/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ItemView: View {
    
    var item: Item
    
    var body: some View {
        VStack{
            //Downloading image from web...
            WebImage(url: URL(string: item.item_image))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width - 30, height: 250)
            
            HStack(spacing: 8){
                Text(item.item_name).font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Spacer(minLength: 0)
                
                //Ratings view...
                ForEach(1...5, id: \.self){
                    index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(item.item_rating) ?? 0 ?
                                            Color(.systemPink) : .gray)
                }
            }
            
            HStack{
                Text(item.item_details)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                
                Spacer(minLength: 0)
            }
        }
    }
}

