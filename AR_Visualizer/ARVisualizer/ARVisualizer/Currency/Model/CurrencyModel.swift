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
    var fluctuation_Start: Float
    var fluctuation_End: Float
    var oneYearAgoValue: Float
    
    var currentValue_columnnModel: ModelEntity = ModelEntity()
    var fluctuation_Start_columnModel: ModelEntity = ModelEntity()
    var fluctuation_End_columnModel: ModelEntity = ModelEntity()
    var oneYearAgoValue_columnModel: ModelEntity = ModelEntity()
    
    var textModel: ModelEntity = ModelEntity()
    
    init(name: String, currentValue: Float, columnnModel: ModelEntity, fluctuation_Start: Float, fluctuation_End: Float, oneYearAgoValue: Float) {
        self.name = name
        self.currentValue = currentValue
        self.currentValue_columnnModel = columnnModel
        self.fluctuation_Start = fluctuation_Start
        self.fluctuation_End = fluctuation_End
        self.oneYearAgoValue = oneYearAgoValue
    }
    
    func updateValue(newValue: Float){
        print("New value for \(name): \(newValue) [OLD: \(currentValue)]")
        currentValue = newValue
        rebuildModel()
    }
    private func rebuildModel(){
        textModel = textGeneration()
        currentValue_columnnModel = columnGeneration(value: currentValue)
        fluctuation_Start_columnModel = columnGeneration(value: fluctuation_Start)
        fluctuation_End_columnModel = columnGeneration(value: fluctuation_End)
        oneYearAgoValue_columnModel = columnGeneration(value: oneYearAgoValue)
    }
    
    private func textGeneration() -> ModelEntity {
        let materialVar = SimpleMaterial(color: .white, roughness: 0, isMetallic: false)
        let depthVar: Float = 0.001
        let fontVar = UIFont.systemFont(ofSize: 0.05)
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
    
    private func columnGeneration(value: Float)->ModelEntity{
        
        let sphereResource = MeshResource.generateBox(width: 0.1, height: value / 2000, depth: 0.1)
        //_ = MeshResource.generateBox(size: 0.08)
        var color: UIColor = .blue
        if name == "EUR" {
            color = .blue
        }
        else if name == "USD"{
            color = .green
        }
        let myMaterial = SimpleMaterial(color: color, roughness: 0, isMetallic: true)
        let myEntity = ModelEntity(mesh: sphereResource, materials: [myMaterial])
        
        return myEntity
    }
}
