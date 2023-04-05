//
//  ContentView.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 04. 04..
//

import SwiftUI
import RealityKit
import ARKit

struct ContentView : View {
    var body: some View {
        ZStack{
            ARViewContainer().edgesIgnoringSafeArea(.all)
            Button("GOMB") {
                print("Nothing")
            }
        }
        
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        // Load the "Box" scene from the "Experience" Reality File
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(boxAnchor)
        
        let sphereResource = MeshResource.generateSphere(radius: 0.05)
        let boxResource = MeshResource.generateBox(size: 0.08)
        
        let myMaterial = SimpleMaterial(color: .blue, roughness: 0, isMetallic: true)
        
        let myEntity = ModelEntity(mesh: sphereResource, materials: [myMaterial])
        
        // Create a new Anchor Entity using Identity Transform.
        let anchorEntity = AnchorEntity()

        // Add the entity as a child of the new anchor.
        anchorEntity.addChild(myEntity)

        // Add the anchor to the scene.
        arView.scene.addAnchor(anchorEntity)
        
        return arView
        
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
