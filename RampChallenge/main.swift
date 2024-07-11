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

func parseHiddenUrl(from html: String) -> URL? {
    let characterSearch = /(<code class="ramp").*?<div class="ramp".*?<span class="ramp".*?<i class="ramp char" value="(?<character>.{1})/

    var combinedString: String = ""

    let results = html.matches(of: characterSearch)
    for result in results {
        combinedString += result.character
    }

    return URL(string: combinedString)
}

func captureTheFlag(url: URL) {
    let session = URLSession.shared
    let request = URLRequest(url: url)

    let task = session.dataTask(with: request) { data, URLResponse, error in
        if let error = error {
            print("Error: \(error)")
            exit(1)
        } else if let data = data {
            print("Data received: \(data)")
            guard let dataString = String(data: data, encoding: .utf8) else { print("Error encoding flag data"); exit(1) }
            print("Flag 👉 " + "\(dataString)")
            exit(0)
        }
    }
    task.resume()
}

getChallengeData() { result in
    switch result {
    case .success(let html):
        guard let url = parseHiddenUrl(from: html) else { print("Error parsing Hidden URL"); exit(1) }
        print("Hidden URL 👉 " + "\(url)")
        captureTheFlag(url: url)
    case .failure(let error):
        print("Error: \(error)")
        exit(1)
    }
}

RunLoop.current.run()
