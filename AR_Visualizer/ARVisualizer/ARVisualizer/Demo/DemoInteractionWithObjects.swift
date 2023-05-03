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
    let controller: CurrencyController = CurrencyController()
    var body: some View {
        InteractionARViewContainer(/*controler: controller*/)//.environmentObject(controller)
    }
}

struct InteractionARViewContainer: UIViewRepresentable {
    //@StateObject var controler:CurrencyController
    
    func makeUIView(context: Context) -> ARView{
        AR.view = ARView(frame: .zero)
        return AR.view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        //print("updating view - \(controler.timerHappened)")
        uiView.scene.anchors.removeAll()
        
        let anchorX = AnchorEntity(world: SIMD3(x: 0.0, y: 0.0, z: 0.0))//SIMD3(x: 0.25, y: 0.0, z: 0.0)
        let myMaterial = SimpleMaterial(color: .gray, roughness: 0, isMetallic: true)
        
        let box = MeshResource.generateBox(size: 0.2)
        let coneMeshResource = try! MeshResource.generateCone(radius: 0.02, height: 0.04)
        
        let coneXEntity = ModelEntity(mesh: coneMeshResource, materials: [myMaterial])
        let boxEntity = ModelEntity(mesh: box, materials: [myMaterial])
        boxEntity.addChild(coneXEntity)
        boxEntity.generateCollisionShapes(recursive: true)
        anchorX.addChild(boxEntity)
        
        uiView.installGestures([.translation, .rotation, .scale], for: boxEntity)
        
        uiView.scene.addAnchor(anchorX)
        print(boxEntity.position)
    }
    
}

struct DemoInteractionWithObjects_Previews: PreviewProvider {
    static var previews: some View {
        DemoInteractionWithObjects()
    }
}
