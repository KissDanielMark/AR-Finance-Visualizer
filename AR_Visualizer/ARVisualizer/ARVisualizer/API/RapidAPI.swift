//
//  RapidAPI.swift
//  ARVisualizer
//
//  Created by Kiss Dániel Márk on 2023. 05. 01..
//

import Foundation


class RapidAPI{
    
    
    func get_data(){
        let headers = [
            "X-RapidAPI-Key": "b90f3a3ae2msh7522a4f087c8388p1df07cjsn5cb32bc028de",
            "X-RapidAPI-Host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://apidojo-yahoo-finance-v1.p.rapidapi.com/auto-complete?q=tesla&region=US")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error as Any)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print("RAPID_API: ")
                print(httpResponse)
            }
        })

        dataTask.resume()
    }
    
}


