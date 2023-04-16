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
    
    @State private var valueOf = 0
    
    var body: some View {
        
        VStack(alignment: .center){
            ZStack(alignment: .bottom){
                ARViewContainer(modelConnfirmedForPlacement: self.$modelConfirmedForPlacement, _valueOf: self.$valueOf).edgesIgnoringSafeArea(.all)
                PhotoButton()
                /*if self.isPlacementActive{
                    PlacementButtons(isPlacementActive: self.$isPlacementActive, selectedModel: self.$selectedModel, modelConfirmedForPlacement: self.$modelConfirmedForPlacement)
                }else{
                    DemoModelPicker(isPlacementActive: self.$isPlacementActive, selectedModel: self.$selectedModel, models: self.models)
                }*/
            }
            _inputSection(_valueOf: self.$valueOf)
            _generatedValue(_valueOf: self.$valueOf)
            
        }
    }
}

struct _generatedValue: View{
    
    @Binding var _valueOf: Int
    
    var body: some View{
        return HStack{
            Label("Generated num.: \(_valueOf)", systemImage: "folder.circle")
        }
    }
}

struct _inputSection: View{
    
    @Binding var _valueOf: Int
    
    var body: some View{
        return HStack{
            Button("Update"){
                self._valueOf = generateRandomValue()
            }
        }
    }
    
    func generateRandomValue() ->Int{
        let randomInt = Int.random(in: 1..<5)
        print(randomInt)
        return randomInt
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
    @Binding var _valueOf: Int
    
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
        //TODO: is it a good solution?
        uiView.scene.anchors.removeAll()
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
        
        let textAnchor = AnchorEntity(world: SIMD3(x: 0.0, y: (Float(_valueOf)/10.0), z: 0.0))
        textAnchor.addChild(textGen(textString: String(_valueOf)).clone(recursive: false))
        uiView.scene.addAnchor(textAnchor)
        
        let ownCube = AnchorEntity(world: SIMD3(x: 0.0, y: 0.0, z: 0.0))
        ownCube.addChild(ownCubeGen(heightOfCube: (Float(_valueOf)/10.0)))
        uiView.scene.addAnchor(ownCube)
    }
    
    func textGen(textString: String) -> ModelEntity {
           
           let materialVar = SimpleMaterial(color: .white, roughness: 0, isMetallic: false)
           
           let depthVar: Float = 0.001
           let fontVar = UIFont.systemFont(ofSize: 0.01)
           let containerFrameVar = CGRect(x: -0.05, y: -0.1, width: 0.1, height: 0.1)
           let alignmentVar: CTTextAlignment = .center
           let lineBreakModeVar : CTLineBreakMode = .byWordWrapping
           
           let textMeshResource : MeshResource = .generateText(textString,
                                              extrusionDepth: depthVar,
                                              font: fontVar,
                                              containerFrame: containerFrameVar,
                                              alignment: alignmentVar,
                                              lineBreakMode: lineBreakModeVar)
           
           let textEntity = ModelEntity(mesh: textMeshResource, materials: [materialVar])
           
           return textEntity
    }
    
    func ownCubeGen(heightOfCube: Float)->ModelEntity{
        
        let sphereResource = MeshResource.generateBox(width: 0.2, height: heightOfCube, depth: 0.2)
        //_ = MeshResource.generateBox(size: 0.08)
        let myMaterial = SimpleMaterial(color: .blue, roughness: 0, isMetallic: true)
        let myEntity = ModelEntity(mesh: sphereResource, materials: [myMaterial])
        
        return myEntity
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
