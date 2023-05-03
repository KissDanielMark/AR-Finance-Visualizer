//
//  CurrencyView.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 04. 16..
//

import SwiftUI
import ARKit
import RealityKit
import FocusEntity
import RealityGeometries

struct CurrencyView: View {
    
    @State private var valueOf = 0
    @State private var isSelectionActive = false
    @State private var selectedCurrency: CurrencyModel?
    @State private var confirmedCurrencyForPlacement: CurrencyModel?
    
    let controller: CurrencyController = CurrencyController()
    
    var body: some View {
        VStack(alignment: .center){
            ZStack(alignment: .bottom){
                CurrencyARViewContainer(/*controler: controller*/).edgesIgnoringSafeArea(.all)//.environmentObject(controller)
                PhotoButton()
                if self.isSelectionActive{
                    CurrencySelectionButtons(controler: self.controller, isSelectionActive: self.$isSelectionActive, selectedCurrency: self.$selectedCurrency, confirmedCurrencyForPlacement: self.$confirmedCurrencyForPlacement)
                }else{
                    CurrencyPicker(isSelectionActive: self.$isSelectionActive, selectedCurrency: self.$selectedCurrency, currencies: self.controller.availableCurrencies)
                }
            }
            //_inputSection(_valueOf: self.$valueOf)
            //_generatedValue(_valueOf: self.$valueOf)
        }
    }
}

struct CurrencyARViewContainer: UIViewRepresentable {
    
    //@StateObject var controler:CurrencyController
    
    func makeUIView(context: Context) -> ARView{
        AR.view = ARView(frame: .zero)
        //_ = FocusEntity(on: AR.view, focus: .classic)
        return AR.view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        //print("updating view - \(controler.timerHappened)")
        uiView.scene.anchors.removeAll()
        
        let cylinderMeshResource = MeshResource.generateBox(size: SIMD3(x: 1.2, y: 0.01, z: 0.01), cornerRadius: 0.1)
        let coneMeshResource = try! MeshResource.generateCone(radius: 0.02, height: 0.04)
        let myMaterial = SimpleMaterial(color: .gray, roughness: 0, isMetallic: true)
        let radians = 90.0 * Float.pi / 180.0
        let kozeppont = AnchorEntity(world: SIMD3(x: 0.0, y: 0.0, z: 0.0))//SIMD3(x: 0.25, y: 0.0, z: 0.0)
        //X
        let axisXEntity = ModelEntity(mesh: cylinderMeshResource, materials: [myMaterial])
        
        let coneXEntity = ModelEntity(mesh: coneMeshResource, materials: [myMaterial])
        coneXEntity.orientation = simd_quatf(angle: radians, axis: SIMD3(x: 0, y: 0, z: -1))
        
        axisXEntity.addChild(coneXEntity)
        coneXEntity.setPosition(SIMD3(x: 0.6, y: 0.0, z: 0.0), relativeTo: axisXEntity)
        
        //uiView.installGestures([.translation, .rotation, .scale], for: axisXEntity)
        
        //Y
        let axisYEntity = ModelEntity(mesh: cylinderMeshResource, materials: [myMaterial])
        axisYEntity.orientation = simd_quatf(angle: radians, axis: SIMD3(x: 0, y: 0, z: 1))
        
        let coneYEntity = ModelEntity(mesh: coneMeshResource, materials: [myMaterial])
        axisYEntity.addChild(coneYEntity)
        coneYEntity.setPosition(SIMD3(x: 0.6, y: 0.0, z: 0.0), relativeTo: axisYEntity)
        coneYEntity.orientation = simd_quatf(angle: radians, axis: SIMD3(x: 0, y: 0, z: -1))
        
        axisXEntity.addChild(axisYEntity)
        
        
        //Z
        let axisZEntity = ModelEntity(mesh: cylinderMeshResource, materials: [myMaterial])
        axisZEntity.orientation = simd_quatf(angle: radians, axis: SIMD3(x: 0, y: 1, z: 0))
        let coneZEntity = ModelEntity(mesh: coneMeshResource, materials: [myMaterial])
        coneZEntity.orientation = simd_quatf(angle: radians, axis: SIMD3(x: 0, y: 0, z: 1))
        coneZEntity.setPosition(SIMD3(x: 0.0, y: 0.0, z: -0.6), relativeTo: axisZEntity)
        axisZEntity.addChild(coneZEntity)
        
        axisXEntity.addChild(axisZEntity)
        
        axisXEntity.generateCollisionShapes(recursive: true)
        axisYEntity.generateCollisionShapes(recursive: true)
        axisZEntity.generateCollisionShapes(recursive: true)
        
        uiView.installGestures([.translation, .rotation, .scale], for: axisXEntity)
        uiView.installGestures([.translation, .rotation, .scale], for: axisYEntity)
        uiView.installGestures([.translation, .rotation, .scale], for: axisZEntity)
       
        kozeppont.addChild(axisXEntity)
        uiView.scene.addAnchor(kozeppont)
        
        /*var index: Float = 0.0
        for i in controler.activeCurrencyModels{
            let textAnchor = AnchorEntity(world: SIMD3(x: index/3.5+0.1+0.01, y: (Float(i.currentValue)/2000.0) + (Float(i.currentValue)/2000.0/2), z: 0.0))
            textAnchor.addChild(i.textModel)
            uiView.scene.addAnchor(textAnchor)
            
            let ownCube = AnchorEntity(world: SIMD3(x: index/3.5+0.1+0.01, y: (Float(i.currentValue)/2000.0 - Float(i.currentValue)/2000.0/2) + 0.01, z: 0.0))
            ownCube.addChild(i.columnnModel)
            uiView.scene.addAnchor(ownCube)
            
            index += 1
        }*/
        
    }
}

struct CurrencyPicker: View {
    @Binding var isSelectionActive: Bool
    @Binding var selectedCurrency: CurrencyModel?
    let currencies: [CurrencyModel]
    
    var body: some View{
        return ScrollView(.horizontal, showsIndicators: false){
            HStack(spacing: 30.0){
                ForEach(0 ..< self.currencies.count, id: \.self){
                    index in
                    Button(action: {
                        print("Selected model: \(self.currencies[index])")
                        isSelectionActive = true
                        self.selectedCurrency = self.currencies[index]
                    }){
                        Label(self.currencies[index].name, systemImage: "dollarsign.square")
                        //Image(uiImage: UIImage (named:self.currencies[index]))
                            //.resizable()
                            .frame(height: 80)
                            .aspectRatio(1/1,contentMode: .fit)
                            .cornerRadius(12)
                            .background(Color.orange.opacity(0.4))
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
        .padding(20)
        .background(Color.black.opacity(0.3))
    }
}

struct CurrencySelectionButtons: View {
    var controler:CurrencyController
    @Binding var isSelectionActive: Bool
    @Binding var selectedCurrency: CurrencyModel?
    @Binding var confirmedCurrencyForPlacement: CurrencyModel?
    
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
                controler.addActiveCurrencyModel(new: self.selectedCurrency!)
                self.confirmedCurrencyForPlacement = self.selectedCurrency
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
        self.isSelectionActive = false
        self.selectedCurrency = nil
    }
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView()
    }
}
