import Foundation

struct Resource {
    private static let apiKey = "89d95dd0dbcd2d3bbfd7e5411c9b54cf"

    let parameters: String
    let method: HtttpMethod

    func url(_ baseURL: String) -> URL? {
        guard let baseURL = URL(string: baseURL) else { return nil }

        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)

        let formatQuery = URLQueryItem(name: "format", value: "json")
        let apiKeyQuery =  URLQueryItem(name: "api_key", value: Resource.apiKey)

        components?.queryItems = [formatQuery, apiKeyQuery]

        if let query = components?.query {
            components?.query = query + "&" +  parameters
        }

        return components?.url
    }
}
