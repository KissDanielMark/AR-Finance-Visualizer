//
//  CurrencyController.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 04. 16..
//

import Foundation
import RealityFoundation

class CurrencyController: ObservableObject{
    
    let availableCurrencies: [CurrencyModel]
    var activeCurrencyModels: [CurrencyModel] = []
    
    @Published var timerHappened = 0
    
    init() {
        //TODO: lekérés megírása
        
        let api = RapidAPI()
        let currency_api = CurrencyAPILayer()
        api.get_data()
        currency_api.convert()
        
        availableCurrencies = [CurrencyModel(name: "EUR", currentValue: 400.0, columnnModel: ModelEntity()), CurrencyModel(name: "USD", currentValue: 300.0, columnnModel: ModelEntity())]
        
        let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func fireTimer() {
        print("Timer fired! - \(timerHappened)")
        timerHappened += 1
        for i in activeCurrencyModels{
            i.updateValue(newValue: Float(Int.random(in: 300..<500)))
        }
    }
    
    func addActiveCurrencyModel(new: CurrencyModel){
        activeCurrencyModels.append(new)
    }
    
}
