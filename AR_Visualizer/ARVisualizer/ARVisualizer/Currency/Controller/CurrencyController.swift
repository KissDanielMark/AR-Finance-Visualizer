//
//  CurrencyController.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 04. 16..
//

import Foundation
import RealityFoundation

class CurrencyController{
    
    let availableCurrencies: [CurrencyModel]
    var activeCurrencyModels: [CurrencyModel] = []
    
    init() {
        //TODO: lekérés megírása
        availableCurrencies = [CurrencyModel(name: "EUR", currentValue: 400.0, columnnModel: ModelEntity()), CurrencyModel(name: "USD", currentValue: 300.0, columnnModel: ModelEntity())]
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func fireTimer() {
        print("Timer fired!")
        for i in activeCurrencyModels{
            i.updateValue(newValue: Float(Int.random(in: 300..<500)))
        }
    }
    
    func addActiveCurrencyModel(new: CurrencyModel){
        activeCurrencyModels.append(new)
    }
    
}
