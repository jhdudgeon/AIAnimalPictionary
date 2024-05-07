//
//  PlayView.swift
//  AI Animal Pictionary
//
//  Created by James Dudgeon on 4/15/24.
//

<<<<<<< HEAD
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
      
=======
import CoreML
import SwiftUI

struct PlayView: View {
  @State private var canvas = Canvas()
  @State private var predictedAnimal: String = ""  // Define predictedAnimal here


  // add MLModel stuff
  private var mlConfig: MLModelConfiguration
  private var model: AIAnimalPictionary_FDCT_?

  private var modelImageWidth: CGFloat = 360
  private var canvasHeight: CGFloat = 300

  init() {
    mlConfig = MLModelConfiguration()
    #if targetEnvironment(simulator)
      mlConfig.computeUnits = .cpuOnly
    #endif

    do {
      model = try AIAnimalPictionary_FDCT_(configuration: mlConfig)
    } catch {
      print("Error creating model: \(error)")
      model = nil
    }

  }
  
  private func createDrawingCanvas()-> some View {
    
    return DrawingCanvas(canvas: $canvas)
                  .frame(width: modelImageWidth, height: modelImageWidth)
                  .frame(maxWidth: .infinity, maxHeight: .infinity)
                  .border(Color.black, width: 2)
      .background(Color.white)
  }

  var body: some View {
    
    let drawingCanvas = createDrawingCanvas()
    
    VStack {
      drawingCanvas
>>>>>>> cole-changes
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
<<<<<<< HEAD
      
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
      
=======

      Button(action: {
        let renderer = ImageRenderer(content: drawingCanvas)
        let image = renderer.uiImage
        predictDrawing(image: image!)
      }) {
        Text("Guess!")
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
      }
      .padding()

>>>>>>> cole-changes
      // Display the predicted animal
      Text("Predicted Animal: \(predictedAnimal)")
        .padding()
        .background(Color.yellow)
        .foregroundColor(.black)
        .fontWeight(.bold)
        .cornerRadius(10)
<<<<<<< HEAD
  }
}
  
  func buffer(from image: UIImage) -> CVPixelBuffer? {
    let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
    var pixelBuffer : CVPixelBuffer?
    let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
    guard (status == kCVReturnSuccess) else {
=======
    }
  }

  func saveTestImage(image: UIImage) {
    // save a copy of the image to the Documents directory of the app
    let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      .first!
    // make a file name that is the current timestamp including milliseconds
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd_HH-mm-ss-SSS"
    let timestamp = formatter.string(from: Date())
    let fileURL = documentsDirectory.appendingPathComponent("resizedImage-\(timestamp).jpg")
    if let data = image.jpegData(compressionQuality: 1.0) {
      try? data.write(to: fileURL)
    }
  }

  func resizeImage(image: UIImage, newSize: CGSize) -> UIImage {

    let horizontalRatio = newSize.width / image.size.width
    let verticalRatio = newSize.height / image.size.height

    let ratio = max(horizontalRatio, verticalRatio)
    let newSize = CGSize(width: image.size.width * ratio, height: image.size.height * ratio)
    var newImage: UIImage

    let isOpaque = false

    if #available(iOS 10.0, *) {
      let renderFormat = UIGraphicsImageRendererFormat.default()
      renderFormat.opaque = false
      let renderer = UIGraphicsImageRenderer(
        size: CGSize(width: newSize.width, height: newSize.height), format: renderFormat)
      newImage = renderer.image {
        (context) in
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
      }
    } else {
      UIGraphicsBeginImageContextWithOptions(
        CGSize(width: newSize.width, height: newSize.height), isOpaque, 0)
      image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
      newImage = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
    }

    // FIXME: remove this
    saveTestImage(image: newImage)

    return newImage
  }

  func buffer(from image: UIImage) -> CVPixelBuffer? {

    // FIXME: save after resize
    saveTestImage(image: image)

    // first resize image to 360x360
    let newSize = CGSize(width: 360, height: 360)
    let newImage = resizeImage(image: image, newSize: newSize)

    let attrs =
      [
        kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
        kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue,
      ] as CFDictionary
    var pixelBuffer: CVPixelBuffer?
    let status = CVPixelBufferCreate(
      kCFAllocatorDefault, Int(newImage.size.width), Int(newImage.size.height),
      kCVPixelFormatType_32ARGB,
      attrs, &pixelBuffer)
    guard status == kCVReturnSuccess else {
>>>>>>> cole-changes
      return nil
    }

    CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
    let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
<<<<<<< HEAD
    let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

    context?.translateBy(x: 0, y: image.size.height)
    context?.scaleBy(x: 1.0, y: -1.0)

    UIGraphicsPushContext(context!)
    image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
=======
    let context = CGContext(
      data: pixelData, width: Int(newImage.size.width), height: Int(newImage.size.height),
      bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!),
      space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

    context?.translateBy(x: 0, y: newImage.size.height)
    context?.scaleBy(x: 1.0, y: -1.0)

    UIGraphicsPushContext(context!)
    newImage.draw(in: CGRect(x: 0, y: 0, width: newImage.size.width, height: newImage.size.height))
>>>>>>> cole-changes
    UIGraphicsPopContext()
    CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

    return pixelBuffer
  }
<<<<<<< HEAD
  
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
=======

  // Function to activate the AI model
  @MainActor func predictDrawing(image: UIImage) {

    if model == nil {
      print("Error: No model. Cannot predict")
      return
    }

    // Prepare Core ML input
    guard let input = try? AIAnimalPictionary_FDCT_Input(image: buffer(from: image)!) else {
      print("Error: Failed to create Core ML input")
      return
    }

    // Perform prediction
    do {
      let prediction = try model?.prediction(input: input)
      predictedAnimal = prediction?.target ?? "FAILED"  // Replace with correct property name
      var predictedConfidence: Double
      predictedConfidence = prediction?.targetProbability[predictedAnimal]! ?? 0.0
      if predictedConfidence > 0.8 {
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
}

struct Canvas {
  var points: [CGPoint] = []
  mutating func addPoint(_ point: CGPoint) {
    points.append(point)
  }
  mutating func clear() {
    points.removeAll()
  }
>>>>>>> cole-changes
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
<<<<<<< HEAD
      .background(Color.white) // Background color for drawing area
=======
      .background(Color.white)  // Background color for drawing area
>>>>>>> cole-changes
      .gesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            let location = value.location
<<<<<<< HEAD
            let scaledLocation = CGPoint(x: location.x / geometry.size.width, y: location.y / geometry.size.height)
            canvas.addPoint(scaledLocation)
          }
      )
      .drawingGroup() // Use drawingGroup for better performance
=======
            let scaledLocation = CGPoint(
              x: location.x / geometry.size.width, y: location.y / geometry.size.height)
            canvas.addPoint(scaledLocation)
          }
      )
      .drawingGroup()  // Use drawingGroup for better performance
>>>>>>> cole-changes
    }
  }
}
