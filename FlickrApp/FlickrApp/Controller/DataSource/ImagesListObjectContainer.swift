import Foundation

@objc protocol ImagesListObject {

}

class ImagesListObjectContainer {
    
    private var images: [ImagesListObject] = []
    private(set) var visibleObjects: [ImagesListObject] = []
    private var nextImageIndex = 0
    
    // when server runs out, set to true
    var noMoreImageInExternalSource = false {
        didSet {
            updateVisibleObjects()
        }
    }
    
    func visibleObject(at index: Int) -> ImagesListObject? {
        guard index < visibleObjects.count else { return nil }
        
        return visibleObjects[index]
    }
    
    func visibleObjectIndex(of object: ImagesListObject) -> Int? {
    }
    
    var visibleObjectsCount: Int {
        return visibleObjects.count
    }
    
    var isCachedFilesRanOut: Bool {
        return images.count == nextImageIndex
    }
    
    func remove(image: ImagesListObject) -> Int? {
        return nil
    }
    
    func insert(image: ImagesListObject) -> Int? {
        images.append(image)
        
    }
    
    func updateImages(with images: [ImagesListObject]) {
        self.images = images
        resetVisibleObjects()
        
        updateVisibleObjects()
    }
    
    @discardableResult
    func updateVisibleObjects() -> Bool {
        var isUpdated = false
        
        while nextImageIndex < images.count {
            let image = images[nextImageIndex]
            

            visibleObjects.append(image)
            nextImageIndex += 1
            isUpdated = true
        }
        
        return isUpdated
    }
    
    private func resetVisibleObjects() {
        nextImageIndex = 0
        visibleObjects = []
    }
    
}
