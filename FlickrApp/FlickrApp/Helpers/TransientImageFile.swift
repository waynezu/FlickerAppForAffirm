import UIKit

class TransientImageFile: NSObject {
    // Use this to cache image info parsed.
    let identifier: String?
    let farmId: Int
    let serverId: String?
    let thumbNailUrl: NSURL?
    let secret: String?
    let height: Int
    let width: Int
    let ownerId: String?
    
    init(withIdentifier id: String?,
         farmId: Int,
         serverId: String?,
         thumbNailUrl: NSURL?,
         secret: String?,
         height: Int,
         width: Int,
         ownerId: String?) {
        self.identifier = id
        self.farmId = farmId
        self.serverId = serverId
        self.thumbNailUrl = thumbNailUrl
        self.secret = secret
        self.height = height
        self.width = width
        self.ownerId = ownerId
    }
}
