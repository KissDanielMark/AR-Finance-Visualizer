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

struct CurrencyView: View {
    
    @State private var valueOf = 0
    @State private var isSelectionActive = false
    @State private var selectedCurrency: CurrencyModel?
    @State private var confirmedCurrencyForPlacement: CurrencyModel?
    
    let controller: CurrencyController = CurrencyController()
    
    var body: some View {
        VStack(alignment: .center){
            ZStack(alignment: .bottom){
                CurrencyARViewContainer(controler: controller).edgesIgnoringSafeArea(.all).environmentObject(controller)
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
    
    @StateObject var controler:CurrencyController
    
    func makeUIView(context: Context) -> ARView{
        AR.view = ARView(frame: .zero)
        //_ = FocusEntity(on: AR.view, focus: .classic)
        return AR.view
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {
        print("updating view - \(controler.timerHappened)")
        uiView.scene.anchors.removeAll()
        var index: Float = 0.0
        for i in controler.activeCurrencyModels{
            let textAnchor = AnchorEntity(world: SIMD3(x: index/2, y: (Float(i.currentValue)/2000.0), z: 0.0))
            textAnchor.addChild(i.textModel)
            uiView.scene.addAnchor(textAnchor)
            
            let ownCube = AnchorEntity(world: SIMD3(x: index/2, y: 0.0, z: 0.0))
            ownCube.addChild(i.columnnModel)
            uiView.scene.addAnchor(ownCube)
            
            index += 1
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

struct CurrencyView_Previews: PreviewProvider {
    static var previews: some View {
        CurrencyView()
    }
}
