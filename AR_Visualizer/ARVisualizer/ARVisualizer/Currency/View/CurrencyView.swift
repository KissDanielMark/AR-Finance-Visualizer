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
                CurrencyARViewContainer(controler: controller).edgesIgnoringSafeArea(.all)
                PhotoButton()
                PauseButton(controler: controller)
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
    
    @StateObject var controler:CurrencyController
    
    func makeUIView(context: Context) -> ARView{
        AR.view = ARView(frame: .zero)
        //_ = FocusEntity(on: AR.view, focus: .classic)
        return AR.view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        print("updating view - \(controler.timerHappened)")
        uiView.scene.anchors.removeAll()
        
        let cylinderMeshResource = MeshResource.generateBox(size: SIMD3(x: 1.2, y: 0.01, z: 0.01), cornerRadius: 0.1)
        let cylinderSmallMeshResource = MeshResource.generateBox(size: SIMD3(x: 0.05, y: 0.01, z: 0.01), cornerRadius: 0.1)
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
        
        let xJelolo1 = ModelEntity(mesh: cylinderSmallMeshResource, materials: [myMaterial])
        axisXEntity.addChild(xJelolo1)
        xJelolo1.orientation = simd_quatf(angle: radians, axis: SIMD3(x: 0, y: 0, z: 1))
        xJelolo1.setPosition(SIMD3(x: (0/3.5+0.1   + 0.0125), y: 0.0, z: 0.0), relativeTo: axisXEntity)
        
        if(!controler.activeCurrencyModels.isEmpty){
            let elsoxSzoveg = textGeneration(value: controler.activeCurrencyModels[0].name)
            axisXEntity.addChild(elsoxSzoveg)
            elsoxSzoveg.setPosition(SIMD3(x: (0/3.5+0.1   + 0.0125), y: -0.05, z: 0.0), relativeTo: axisXEntity)
        }
        
        
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
        
        uiView.installGestures([.translation, .rotation], for: axisXEntity)
       
        kozeppont.addChild(axisXEntity)
        uiView.scene.addAnchor(kozeppont)
        
        var index: Float = 0.0
        for i in controler.activeCurrencyModels{
           
            i.currentValue_columnnModel.addChild(i.textModel)
            i.textModel.setPosition(SIMD3(x: 0.0, y: (Float(i.currentValue)/2000.0) + (Float(i.currentValue)/2000.0/2), z: 0.0), relativeTo: i.currentValue_columnnModel)
            
            
            axisXEntity.addChild(i.currentValue_columnnModel)
            i.currentValue_columnnModel.setPosition(SIMD3(x: index/3.5+0.1+0.01, y: (Float(i.currentValue)/2000.0 - Float(i.currentValue)/2000.0/2) + 0.01, z: 0.0), relativeTo: axisXEntity)
            
            
            axisXEntity.addChild(i.fluctuation_Start_columnModel)
            i.fluctuation_Start_columnModel.setPosition(SIMD3(x: index/3.5+0.1+0.01, y: (Float(i.fluctuation_Start)/2000.0 - Float(i.fluctuation_Start)/2000.0/2) + 0.01, z: -0.2), relativeTo: axisXEntity)
            
            axisXEntity.addChild(i.fluctuation_End_columnModel)
            i.fluctuation_End_columnModel.setPosition(SIMD3(x: index/3.5+0.1+0.01, y: (Float(i.fluctuation_End)/2000.0 - Float(i.fluctuation_End)/2000.0/2) + 0.01, z: -0.4), relativeTo: axisXEntity)
            
            axisXEntity.addChild(i.oneYearAgoValue_columnModel)
            i.oneYearAgoValue_columnModel.setPosition(SIMD3(x: index/3.5+0.1+0.01, y: (Float(i.oneYearAgoValue)/2000.0 - Float(i.oneYearAgoValue)/2000.0/2) + 0.01, z: -0.6), relativeTo: axisXEntity)
            
            index += 1
            
            i.currentValue_columnnModel.generateCollisionShapes(recursive: true)
            uiView.installGestures([.translation], for: i.currentValue_columnnModel)
        }
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

struct PauseButton: View{
    @StateObject var controler:CurrencyController
    var body: some View{
        return VStack{
            Button {
                controler.pauseResume()
              } label: {
                  Image(systemName: controler.isPaused ? "play":"pause")
                  .frame(width:60, height:60)
                  .font(.title)
                  .background(.gray.opacity(0.75))
                  .cornerRadius(30)
                  .padding()
              }
        }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

private func textGeneration(value:  String) -> ModelEntity {
    let materialVar = SimpleMaterial(color: .white, roughness: 0, isMetallic: false)
    let depthVar: Float = 0.001
    let fontVar = UIFont.systemFont(ofSize: 0.025)
    let containerFrameVar = CGRect(x: -0.05, y: -0.1, width: 0.1, height: 0.1)
    let alignmentVar: CTTextAlignment = .center
    let lineBreakModeVar : CTLineBreakMode = .byWordWrapping
   
    let textMeshResource : MeshResource = .generateText(String(value),
                                      extrusionDepth: depthVar,
                                      font: fontVar,
                                      containerFrame: containerFrameVar,
                                      alignment: alignmentVar,
                                      lineBreakMode: lineBreakModeVar)
   
    let textEntity = ModelEntity(mesh: textMeshResource, materials: [materialVar])
   
    return textEntity
}

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView()
    }
}
