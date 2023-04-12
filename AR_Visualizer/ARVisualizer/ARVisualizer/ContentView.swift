//
//  ContentView.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 04. 04..
//

import SwiftUI
import RealityKit
import ARKit
import FocusEntity

struct AR {
  static var view: ARView!
}

struct ContentView : View {
    
    let models: [Model] = [Model(modelName: "teapot"), Model(modelName: "toy_biplane_idle")]
    @State private var isPlacementActive = false
    @State private var selectedModel: Model?
    @State private var modelConfirmedForPlacement: Model?
    
    var body: some View {
        ZStack(alignment: .bottom){
            ARViewContainer(modelConnfirmedForPlacement: self.$modelConfirmedForPlacement).edgesIgnoringSafeArea(.all)
            PhotoButton()
            if self.isPlacementActive{
                PlacementButtons(isPlacementActive: self.$isPlacementActive, selectedModel: self.$selectedModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
            }else{
                DemoModelPicker(isPlacementActive: self.$isPlacementActive, selectedModel: self.$selectedModel, models: self.models)
            }
        }
    }
}

struct PlacementButtons: View{
    @Binding var isPlacementActive: Bool
    @Binding var selectedModel: Model?
    @Binding var modelConfirmedForPlacement: Model?
    
    var body: some View{
        return HStack{
            Button(action: {resetPlacement()}){
                Image(systemName: "xmark")
                    .frame(width: 60,height: 60)
                    .font(.title)
                    .background(Color.red.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
            
            Button(action: {
                self.modelConfirmedForPlacement = self.selectedModel
                resetPlacement()
            }){
                Image(systemName: "checkmark")
                    .frame(width: 60,height: 60)
                    .font(.title)
                    .background(Color.green.opacity(0.75))
                    .cornerRadius(30)
                    .padding(20)
            }
        }
    }
    
    func resetPlacement(){
        self.isPlacementActive = false
        self.selectedModel = nil
    }
}

struct DemoModelPicker: View{
    @Binding var isPlacementActive: Bool
    @Binding var selectedModel: Model?
    let models: [Model]
    
    var body: some View{
        return ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 30.0){
                ForEach(0 ..< self.models.count, id: \.self){
                    index in
                    Button(action: {
                        print("Selected model: \(self.models[index].modelName)")
                        isPlacementActive = true
                        self.selectedModel = self.models[index]
                    }){
                        Image(uiImage: self.models[index].image)
                            .resizable()
                            .frame(height: 60)
                            .aspectRatio(1/1,contentMode: .fit)
                            .cornerRadius(12)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.3))
    }
}

struct PhotoButton: View{
    var body: some View{
        return VStack{
            Button {
                AR.view.snapshot(saveToHDR: false) { (image) in
                  let compressedImage = UIImage(data: (image?.pngData())!)
                  UIImageWriteToSavedPhotosAlbum(compressedImage!, nil, nil, nil)
                }
              } label: {
                Image(systemName: "camera")
                  .frame(width:60, height:60)
                  .font(.title)
                  .background(.gray.opacity(0.75))
                  .cornerRadius(30)
                  .padding()
              }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    @Binding var modelConnfirmedForPlacement: Model?
    
    func makeUIView(context: Context) -> ARView {
        AR.view = ARView(frame: .zero)
        let focusSquare = FocusEntity(on: AR.view, focus: .classic)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        
//      DOCUMENTATION: this is for LiDAR capable devices
        if ARWorldTrackingConfiguration.supportsSceneReconstruction(.mesh){
            configuration.sceneReconstruction = .mesh
        }
        
        AR.view.session.run(configuration)
        
        return AR.view
    }
    func updateUIView(_ uiView: ARView, context: Context) {
        if let model = self.modelConnfirmedForPlacement{
            print("Addig \(model.modelName) model to the Scene")
            
            if let modelEntity = model.modelEntity{
                let anchorEntity = AnchorEntity(plane: .any)
                anchorEntity.addChild(modelEntity.clone(recursive: true))//to place multiple from the same model
                uiView.scene.addAnchor(anchorEntity)
            }
            else{
                print("Model is not available")
            }
            DispatchQueue.main.async {
                self.modelConnfirmedForPlacement = nil
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
