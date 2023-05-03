//
//  DemoInteractionWithObjects.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 05. 03..
//

import SwiftUI
import ARKit
import RealityKit

struct DemoInteractionWithObjects: View {
    var body: some View {
        InteractionARViewContainer()
    }
}

struct InteractionARViewContainer: UIViewRepresentable {

    
    func makeUIView(context: Context) -> ARView{
        AR.view = ARView(frame: .zero)
        return AR.view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        
        let anchorX = AnchorEntity(world: SIMD3(x: 0.0, y: 0.0, z: 0.0))//SIMD3(x: 0.25, y: 0.0, z: 0.0)
        let myMaterial = SimpleMaterial(color: .gray, roughness: 0, isMetallic: true)
        let box = MeshResource.generateBox(size: 0.2)
        let boxEntity = ModelEntity(mesh: box, materials: [myMaterial])
        boxEntity.generateCollisionShapes(recursive: true)
        anchorX.addChild(boxEntity)
        
        uiView.installGestures([.translation, .rotation, .scale], for: boxEntity)
        
        uiView.scene.addAnchor(anchorX)
    }
}

struct DemoInteractionWithObjects_Previews: PreviewProvider {
    static var previews: some View {
        DemoInteractionWithObjects()
    }
}
