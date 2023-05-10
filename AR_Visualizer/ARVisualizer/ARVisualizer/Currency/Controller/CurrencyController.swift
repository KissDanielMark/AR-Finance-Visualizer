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
    var timer = Timer()
    @Published var isPaused = false
    let timerInterval = 10.0
    @Published var timerHappened = 0
    var currency_api: CurrencyAPILayer
    
    init() {
        //TODO: lekérés megírása
        
        //let api = RapidAPI()
        currency_api = CurrencyAPILayer()
        currency_api.convert(mire: "EUR")
        //currency_api.convert(mire: "USD")
        //currency_api.fluctuation()
        //api.get_data()
        
        
        availableCurrencies =
        [
            CurrencyModel(name: "EUR", currentValue: Float(currency_api.eurCurrent), columnnModel: ModelEntity(), fluctuation_Start: 300.0, fluctuation_End: 340.0, oneYearAgoValue: 200),
            CurrencyModel(name: "USD", currentValue: Float(currency_api.usdCurrent), columnnModel: ModelEntity(), fluctuation_Start: 400.0, fluctuation_End: 500.0, oneYearAgoValue: 100.0)
        ]
        
        timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func fireTimer() {
        print("Timer fired! - \(timerHappened)")
        timerHappened += 1
        currency_api.convert(mire: "EUR")
        for i in activeCurrencyModels{
            if(i.name == "EUR")
            {
                i.updateValue(newValue: Float(currency_api.eurCurrent))
            }
            else if(i.name == "USD")
            {
                i.updateValue(newValue: Float(currency_api.usdCurrent))
            }
            
        }
    }
    
    func pauseResume(){
        if isPaused{
            timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector:  #selector(fireTimer), userInfo: nil, repeats: true)
                isPaused = false
        }
        else{
            print("Paused")
            timer.invalidate()
            isPaused = true
        }
    }
    
    func addActiveCurrencyModel(new: CurrencyModel){
        activeCurrencyModels.append(new)
    }
    
}
