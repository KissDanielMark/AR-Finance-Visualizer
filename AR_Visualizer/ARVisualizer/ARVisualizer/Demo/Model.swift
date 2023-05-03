//
//  Model.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 04. 12..
//

import Foundation
import UIKit
import RealityKit
import Combine

class Model {
    
    var modelName: String
    var image: UIImage
    var modelEntity: ModelEntity?
    
    private var cancellable: AnyCancellable? = nil
    
    init (modelName: String) {
        self.modelName = modelName
        self.image = UIImage (named: modelName)!
        
        let filename = modelName + ".usdz"
        self.cancellable = ModelEntity.loadModelAsync (named: filename).sink(receiveCompletion: { loadCompletion in
            // Handle our error
            print ("DEBUG: Unable to load modelentity for modelName: \(self .modelName)")
        }, receiveValue: { modelEntity in
            // Get our modelEntity
            print("Model loaded sucessfully")
            self.modelEntity = modelEntity
        })
    }
    
}
