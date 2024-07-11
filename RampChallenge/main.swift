import Foundation

enum ChallengeError: Error {
    case encoding
}

func getChallengeData(completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: "https://tns4lpgmziiypnxxzel5ss5nyu0nftol.lambda-url.us-east-1.on.aws/challenge") else { return }

    let session = URLSession.shared
    let request = URLRequest(url: url)

    let task = session.dataTask(with: request) { data, URLResponse, error in
        if let error = error {
            completion(.failure(error))
        } else if let data = data {
            print("Data received: \(data)")
            guard let dataString = String(data: data, encoding: .utf8) else { return completion(.failure(ChallengeError.encoding)) }
            completion(.success(dataString))
        }
    }
    task.resume()
}

func parseHiddenUrl(from html: String) -> String {
    let characterSearch = /(<code class="ramp").*?<div class="ramp".*?<span class="ramp".*?<i class="ramp char" value="(?<character>.{1})/

    var combinedString: String = ""

    let results = html.matches(of: characterSearch)
    for result in results {
        combinedString += result.character
    }

    return combinedString
}

getChallengeData() { result in
    switch result {
    case .success(let html):
        let url = parseHiddenUrl(from: html)
        print("Hidden URL:" + "\(url)")
        exit(0)
    case .failure(let error):
        print("Error: \(error)")
        exit(1)
    }
}

RunLoop.current.run()
