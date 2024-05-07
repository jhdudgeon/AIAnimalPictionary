//
//  LandingView.swift
//  AI Animal Pictionary
//
//  Created by James Dudgeon on 4/15/24.
//

import SwiftUI
import AVKit
import AVFoundation

struct LandingView: View {
  @State private var audioPlayer: AVAudioPlayer?
  var body: some View {
    NavigationView {
      ZStack {
        Image("Clouds") // Background Picture
          .resizable()
          .scaledToFill()
          .edgesIgnoringSafeArea(.all)
        
        VStack {
          Spacer()
          
          Text("AI Animal Pictionary!")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.top, 200)
          
            .padding()
          
          VStack(spacing: 10) {
            
            NavigationLink(destination: PlayView()) {
              Text("Play")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
            
            NavigationLink(destination: InstructionsView()) {
              Text("Instructions")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding()
            
            Spacer()
          }
          .onAppear {
            // Load the audio file
            if let audioURL = Bundle.main.url(forResource: "Elevator_Ride.mp3", withExtension: "mp3") {
              do {
                // Initialize the audio player
                audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
                // Set the audio player to loop indefinitely
                audioPlayer?.numberOfLoops = -1
                // Play the audio
                audioPlayer?.play()
              } catch {
                print("Error playing audio: \(error.localizedDescription)")
              }
            }
          }
              .navigationTitle("") // Hide navigation bar title
              .navigationBarHidden(true) // Hide navigation bar
          }
        }
      }
    }
  }
