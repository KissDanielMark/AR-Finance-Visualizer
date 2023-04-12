//
//  ARViewContainer.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 04. 12..
//

import SwiftUI
import ARKit
import RealityKit


struct ARVariables{
  static var arView: ARView!
}

struct DemoContentView: View {
    var body: some View {
        ZStack{
            ARViewContainer().edgesIgnoringSafeArea(.all)
            VStack{
                Button {
                    // Placeholder: take a snapshot
                    ARVariables.arView.snapshot(saveToHDR: false) { (image) in
                      // Compress the image
                      let compressedImage = UIImage(data: (image?.pngData())!)
                      // Save in the photo album
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

struct DemoARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        ARVariables.arView = ARView(frame: .zero)
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        // Add the box anchor to the scene
        ARVariables.arView.scene.anchors.append(boxAnchor)
        let sphereResource = MeshResource.generateSphere(radius: 0.05)
        //_ = MeshResource.generateBox(size: 0.08)
        let myMaterial = SimpleMaterial(color: .blue, roughness: 0, isMetallic: true)
        let myEntity = ModelEntity(mesh: sphereResource, materials: [myMaterial])
        // Add the entity as a child of the new anchor.
        let anchorEntity = AnchorEntity()
        anchorEntity.addChild(myEntity)
        ARVariables.arView.scene.addAnchor(anchorEntity)
        // Add the anchor to the scene.
        ARVariables.arView.scene.addAnchor(create3DText())
        
        let textAnchor = AnchorEntity()
        textAnchor.addChild(textGen(textString: "Testing"))
        ARVariables.arView.scene.addAnchor(textAnchor)
        
        return ARVariables.arView
    }
    
    func create3DText() -> AnchorEntity{
        let ownTextObjectVertices: MeshResource = .generateText(
            "HALO",
            extrusionDepth: 0.001,
            font: UIFont.systemFont(ofSize: 0.03),
            containerFrame: CGRect(x: 0.0, y: 0.0, width: 0.2, height: 0.2),
            alignment:  .center,
            lineBreakMode: .byWordWrapping
        )
        let myMaterial2 = SimpleMaterial(color: .red, roughness: 0, isMetallic: false)
        let ownTextModel = ModelEntity(mesh: ownTextObjectVertices, materials: [myMaterial2])
        
        // Create a new Anchor Entity using Identity Transform.
        let anchorEntity = AnchorEntity()
        // Add the entity as a child of the new anchor.
        anchorEntity.addChild(ownTextModel)
        return anchorEntity
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
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

struct ARViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        ARViewContainer()
    }
}
