//
//  PlayView.swift
//  AI Animal Pictionary
//
//  Created by James Dudgeon on 4/15/24.
//

import SwiftUI
import CoreML

struct PlayView: View {
  @State private var canvas = Canvas()
  @State private var predictedAnimal: String = "" // Define predictedAnimal here
  var body: some View {
    VStack {
      DrawingCanvas(canvas: $canvas)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .border(Color.white, width: 6) // Optional border
      
      Button(action: {
        canvas.clear()
        predictedAnimal = ""
      }) {
        Text("Clear")
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
      }
      
      Button(action: {
          predictDrawing()
      }) {
          Text("Guess!")
              .padding()
              .background(Color.blue)
              .foregroundColor(.white)
              .cornerRadius(10)
      }
      .padding()
      
      // Display the predicted animal
      Text("Predicted Animal: \(predictedAnimal)")
        .padding()
        .background(Color.yellow)
        .foregroundColor(.black)
        .fontWeight(.bold)
        .cornerRadius(10)
  }
}
  
  func buffer(from image: UIImage) -> CVPixelBuffer? {
    let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
    var pixelBuffer : CVPixelBuffer?
    let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
    guard (status == kCVReturnSuccess) else {
      return nil
    }

    CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

    context?.translateBy(x: 0, y: image.size.height)
    context?.scaleBy(x: 1.0, y: -1.0)

    UIGraphicsPushContext(context!)
    image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
    UIGraphicsPopContext()
    CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

    return pixelBuffer
  }
  
  // Function to activate the AI model
  func predictDrawing() {
      // Convert the canvas drawing to a UIImage object
      guard let image = convertCanvasToUIImage() else {
          print("Error: Failed to convert canvas to UIImage")
          return
      }
      
      // Load your Core ML model
      let mlConfig = MLModelConfiguration()
// #if targetEnvironment(simulator)
      mlConfig.computeUnits = .cpuOnly
// #endif
       
      guard let model = try? AIAnimalPictionary_FDCT_(configuration: mlConfig) else {
          print("Error: Failed to load Core ML model")
          return
      }
      
      // Prepare Core ML input
    guard let input = try? AIAnimalPictionary_FDCT_Input(image: buffer(from: image)!) else {
          print("Error: Failed to create Core ML input")
          return
      }
      
      // Perform prediction
      do {
          let prediction = try model.prediction(input: input)
        predictedAnimal = prediction.target // Replace with correct property name
        var predictedConfidence : Double;
        predictedConfidence = prediction.targetProbability[predictedAnimal]!
        if( predictedConfidence > 0.8){
          predictedAnimal += String(format: " %.0f", floor(predictedConfidence * 100))
          predictedAnimal += "%"
          
          // if confidence is 0... they didn't get it
          print("prediction is: \(predictedAnimal)")
        }
      } catch {
          print("Error making prediction: \(error)")
          predictedAnimal = "YOU SUCK AT ART!!!"
      }
  }
  
  func convertCanvasToUIImage() -> UIImage? {
      let renderer = UIGraphicsImageRenderer(size: CGSize(width: 300, height: 300)) // Adjust size as needed
      let image = renderer.image { context in
          // Render the canvas drawing here
          let center = CGPoint(x: 150, y: 150) // Adjust coordinates as needed
          let radius: CGFloat = 50
          UIColor.red.setFill()
          context.cgContext.fillEllipse(in: CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
      }
      return image
  }
}
  

struct Canvas {
    var points: [CGPoint] = []
    mutating func addPoint(_ point: CGPoint) {
        points.append(point)
    }
    mutating func clear() {
        points.removeAll()
    }
}

struct DrawingCanvas: View {
  @Binding var canvas: Canvas
  var body: some View {
    GeometryReader { geometry in
      Path { path in
        for point in canvas.points {
          let x = point.x * geometry.size.width
          let y = point.y * geometry.size.height
          if path.isEmpty {
            path.move(to: CGPoint(x: x, y: y))
          } else {
            path.addLine(to: CGPoint(x: x, y: y))
          }
        }
      }
      .stroke(Color.black, lineWidth: 5)
      .background(Color.white) // Background color for drawing area
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            let location = value.location
            let scaledLocation = CGPoint(x: location.x / geometry.size.width, y: location.y / geometry.size.height)
            canvas.addPoint(scaledLocation)
          }
      )
      .drawingGroup() // Use drawingGroup for better performance
    }
  }
}
