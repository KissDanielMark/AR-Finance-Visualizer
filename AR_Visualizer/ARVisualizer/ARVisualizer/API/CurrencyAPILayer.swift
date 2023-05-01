//
//  CurrencyAPILayer.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 05. 01..
//

import Foundation

class CurrencyAPILayer{
    
    private let apiKey = "YNIJuQBfnnnQvmVHMDooFtGY4nE6u0Rj"
    
    func convert(){
        var semaphore = DispatchSemaphore (value: 0)

        let url = "https://api.apilayer.com/exchangerates_data/convert?to=HUF&from=USD&amount=1"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.addValue("\(apiKey)", forHTTPHeaderField: "apikey")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    }
    
    
}
