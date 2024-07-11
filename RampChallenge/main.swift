//
//  main.swift
//  RampChallenge
//
//  Created by Justin Vallely on 7/11/24.
//

import Foundation

print("Hello, World!")

func getChallengeData() {
    guard let url = URL(string: "https://tns4lpgmziiypnxxzel5ss5nyu0nftol.lambda-url.us-east-1.on.aws/challenge") else { return }

    let session = URLSession.shared
    let request = URLRequest(url: url)

    let task = session.dataTask(with: request) { data, URLResponse, error in
        if let error = error {
            print("Error: \(error.localizedDescription)")
            exit(1)
        } else if let data = data {
            print("Data received: \(data)")
            guard let dataString = String(data: data, encoding: .utf8) else { exit(2) }
            print("👉 " + "dataString:\n\(dataString)")
            exit(0)
        }
    }
    task.resume()
}

getChallengeData()

RunLoop.current.run()
