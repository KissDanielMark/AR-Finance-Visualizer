//
//  CurrencyModel.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 04. 16..
//
import SwiftUI
import Foundation
import RealityFoundation

class CurrencyModel{
    
    let name: String
    var currentValue: Float
    var columnnModel: ModelEntity
    
    init(name: String, currentValue: Float, columnnModel: ModelEntity) {
        self.name = name
        self.currentValue = currentValue
        self.columnnModel = columnnModel
    }
    
    func updateValue(newValue: Float){
        currentValue = newValue
        rebuildModel()
    }
    func rebuildModel(){
        textGeneration()
        columnnModel = columnGeneration()
    }
    
    func textGeneration() -> ModelEntity {
        let materialVar = SimpleMaterial(color: .white, roughness: 0, isMetallic: false)
        let depthVar: Float = 0.001
        let fontVar = UIFont.systemFont(ofSize: 0.03)
        let containerFrameVar = CGRect(x: -0.05, y: -0.1, width: 0.1, height: 0.1)
        let alignmentVar: CTTextAlignment = .center
        let lineBreakModeVar : CTLineBreakMode = .byWordWrapping
       
        let textMeshResource : MeshResource = .generateText(String(currentValue),
                                          extrusionDepth: depthVar,
                                          font: fontVar,
                                          containerFrame: containerFrameVar,
                                          alignment: alignmentVar,
                                          lineBreakMode: lineBreakModeVar)
       
        let textEntity = ModelEntity(mesh: textMeshResource, materials: [materialVar])
       
        return textEntity
    }
    
    func columnGeneration()->ModelEntity{
        
        let sphereResource = MeshResource.generateBox(width: 0.2, height: currentValue / 1000, depth: 0.2)
        //_ = MeshResource.generateBox(size: 0.08)
        let myMaterial = SimpleMaterial(color: .blue, roughness: 0, isMetallic: true)
        let myEntity = ModelEntity(mesh: sphereResource, materials: [myMaterial])
        
        return myEntity
    }
}
