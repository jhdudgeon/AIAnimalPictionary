//
//  InstructionsView.swift
//  AI Animal Pictionary
//
//  Created by James Dudgeon on 4/15/24.
//

import SwiftUI

struct InstructionsView: View {
  var body: some View {
    NavigationView {
      ZStack {
        Image("Clouds") // Use the same background image as the landing page
          .resizable()
          .scaledToFill()
          .edgesIgnoringSafeArea(.all)
        
        VStack {
          Spacer()
          
          Text("Welcome to:")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding()
            .multilineTextAlignment(.center)
          
          Text("AI Animal Pictionary!")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.yellow)
            .padding()
            .multilineTextAlignment(.center)
          
          
          Text("How to Play:")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .padding()
            .multilineTextAlignment(.center)
          
          VStack(alignment: .leading, spacing: 10) {
            Text("• Press Play")
              .foregroundColor(.black)
            Text("• Draw your creation")
              .foregroundColor(.black)
            Text("• Tap “Guess!”")
              .foregroundColor(.black)
            Text("• See your results!")
              .foregroundColor(.black)
          }
          .padding()
          
          Text("Possible Animals:")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.black)
            .padding()
            .multilineTextAlignment(.center)
          
          VStack(alignment: .leading, spacing: 10) {
            Text("• Chicken")
              .foregroundColor(.black)
            Text("• Dog")
              .foregroundColor(.black)
            Text("• Fish")
              .foregroundColor(.black)
            Text("• T-Rex")
              .foregroundColor(.black)
          }
          .padding()
          
          Spacer()
          
          NavigationLink(destination: ReferenceDrawingsView()) {
            Text("Reference Drawings")
              .foregroundColor(.white)
              .padding()
              .background(Color.blue)
              .cornerRadius(10)
          }
          .padding()
          
          Text("Developed by James Dudgeon, 2024")
            .font(.system(size: 12))
            .fontWeight(.thin)
            .foregroundColor(.black)
            .padding()
            .multilineTextAlignment(.center)
        }
      }
      .navigationTitle("Instructions") // Hide navigation bar title
      .navigationBarHidden(true) // Hide navigation bar
    }
  }
}

struct ReferenceDrawingsView: View {
  var body: some View {
    ScrollView {
      VStack {
        Text("Reference Drawings:")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .padding()
          .multilineTextAlignment(.center)
        
        ReferenceDrawingView(imageName: "Chicken", title: "Chicken:")
        ReferenceDrawingView(imageName: "Dog", title: "Dog:")
        ReferenceDrawingView(imageName: "Fish", title: "Fish:")
        ReferenceDrawingView(imageName: "Trex", title: "T-Rex:")
        
        Spacer()
      }
      .background(Color.black.edgesIgnoringSafeArea(.all))
    }
  }
}

struct ReferenceDrawingView: View {
  var imageName: String
  var title: String
  
  var body: some View {
    VStack {
      Text(title)
        .font(.headline)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding()
        .multilineTextAlignment(.center)
      
      Image(imageName)
        .resizable()
        .aspectRatio(contentMode: .fit)
        .padding()
    }
  }
}
