//
//  ContentView.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 04. 04..
//

import SwiftUI
import RealityKit
import ARKit

struct AR{
  static var view: ARView!
}

struct ContentView : View {
    var body: some View {
        ZStack{
            DemoARViewContainer().edgesIgnoringSafeArea(.all)
            VStack{
                Button {
                    AR.view.snapshot(saveToHDR: false) { (image) in
                      let compressedImage = UIImage(data: (image?.pngData())!)
                      UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
                    }
                  } label: {
                    Image(systemName: "camera")
                      .frame(width:60, height:60)
                      .font(.title)
                      .background(.white.opacity(0.75))
                      .cornerRadius(30)
                      .padding()
                  }
            }.frame(maxHeight: .infinity, alignment: .bottom)
            
        }
        
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        AR.view = ARView(frame: .zero)
        
        return AR.view
    }
    func updateUIView(_ uiView: ARView, context: Context) {}
}



#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
