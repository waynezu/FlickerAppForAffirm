import UIKit

public protocol SearchClientImageDelegate: class {
    func searchClient(_ searchClient: AnySearchClient, didFetchImage image: UIImage?, atUrl url: String)
}

public protocol SearchClientDataDelegate: class {
    func searchClient(_ searchClient: AnySearchClient, didFetchImageData imageData: [TransientImageFile])
}

public protocol AnySearchClient: class {
    var imageDelegate: SearchClientImageDelegate? { get set }
    var dataDelegate: SearchClientDataDelegate? { get set }
    
    func fetchImage(_ url: String)
    func fetchImageData(searchString: String)
}

class SearchClient: NSObject, AnySearchClient {
    // Use this to connect to Flickr and download medium size image for preview, and displayed in SearchResultViewController
    private struct Constants {
        static let baseApiUrl = "//api.flickr.com/services/rest/"
        static let searchApiKey = "?method=flickr.photos.search&api_key=675894853ae8ec6c242fa4c077bcf4a0&text="
        static let apiSuffix = "&extras=url_s&format=json&nojsoncallback=1"
    }
    
    private let httpClient: AFHTTPClientProtocol
    weak var imageDelegate: SearchClientImageDelegate?
    weak var dataDelegate: SearchClientDataDelegate?
    
    private let searchClientQueue = DispatchQueue(label: "search_client_queue", attributes: [])
    private let getImageQueue = DispatchQueue(label: "get_image_queue", attributes: [])
    
    private var requestedImageUrls = Set<String>()
    
    //TODO: Need to import a third party lib for httpClient
    override init(httpClient: AFHTTPClient) {
        self.httpClient = httpClient
        super.init()
    }
    
    func fetchImageData(searchString: String) {
        Dispatcher.dispatchAsync(queue: searchClientQueue) {
            let url = Constants.baseApiUrl + Constants.searchApiKey + searchString + Constants.apiSuffix
            let request = self.httpClient.request(withMethod: "GET", path: url, parameters: nil)
            
            let operation = self.httpClient.httpRequestOperation(with: request as URLRequest, success: { (_, responseObject) in
                if let responseObject = responseObject as [String: Any], let photosData = responseObject["photos"] as [String: Any], let imagesData = photosData["photo"] as [[String: Any]] {
                    var returnedData = [TransientImageFile]()
                    for data in imagesData {
                        let id = data["id"]
                        let farmId = data["farm"] as? Int
                        let serverId = data["server"]
                        let thumbNailUrl = data["url_s"] as NSURL
                        let secret = data["secret"]
                        let height = (data["height_s"] as String) ? Int(data["height_s"]) : 0
                        let width = (data["width_s"] as String) ? Int(data["width_s"]) : 0
                        let ownerId = data["owner"]
                        let imageFile = TransientImageFile(withIdentifier: id, farmId: farmId, serverId: serverId, thumbNailUrl: thumbNailUrl, secret: secret, height: height, width: width, ownerId: ownerId)
                        returnedData.append(imageFile)
                    }
                    self.dataDelegate?.searchClient(self, didFetchImageData: returnedData)
                } else {
                    // Handle fail
                }
            }, failure: { (_, error) in
                //
            })
            
            operation.successCallbackQueue = self.searchClientQueue
            operation.failureCallbackQueue = self.searchClientQueue
            self.httpClient.enqueue(operation)
        }
    }
    
    func fetchImage(_ url: String) {
        Dispatcher.dispatchAsync(queue: getImageQueue) {
            guard !self.requestedImageUrls.contains(url) else { return }
            
            self.requestedImageUrls.insert(url)
            
            let request = self.httpClient.request(withMethod: "GET", path: url, parameters: nil)
            
            let operation = self.httpClient.imageRequestOperation(with: request as URLRequest, imageProcessingBlock: nil, success: { [weak self] (_, _, image) in
                guard let `self` = self else { return }
                self.requestedImageUrls.remove(url)
                if let width = image?.size.width,
                    let height = image?.size.height,
                    width > 0 && height > 0 {
                    self.imageDelegate?.searchClient(self, didFetchImage: image, atUrl: url)
                } else {
                    self.imageDelegate?.searchClient(self, didFetchImage: nil, atUrl: url)
                }
                }, failure: { [weak self] (_, response, error) in
                    guard let `self` = self else { return }
                    logError("Error fetching image \(String(describing: response?.statusCode)) - \(error.debugDescription)")
                    // TODO: could use a backoff counter
                    self.requestedImageUrls.remove(url)
                    self.imageDelegate?.searchClient(self, didFetchImage: nil, atUrl: url)
            })
            
            operation.successCallbackQueue = self.getImageQueue
            operation.failureCallbackQueue = self.getImageQueue
            self.httpClient.enqueue(operation)
        }
    }

}
