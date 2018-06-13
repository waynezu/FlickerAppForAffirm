import Foundation

enum ImagesListObjectType {
    case jpg
    case png
    case gif
}

protocol ImagesListDataSourceDelegate: class {
    func datasourceWillChangeContent(_ datasource: ImageListsDataSourceProtocol)
    func datasourceDidChangeContent(_ datasource: ImageListsDataSourceProtocol)
    func datasource(_ datasource: ImageListsDataSourceProtocol, didInsert anObject: ImagesListObject, at indexPath: IndexPath)
    func datasource(_ datasource: ImageListsDataSourceProtocol, didDelete anObject: ImagesListObject, at indexPath: IndexPath)
    func datasource(_ datasource: ImageListsDataSourceProtocol, didUpdate anObject: ImagesListObject, at indexPath: IndexPath)
}

protocol ImageListsDataSourceProtocol {
    typealias FetchCompletionBlock = (Bool, FilesListObjectType) -> Void
    typealias FetchStartBlock = (FilesListObjectType) -> Void
    
    var delegate: ImagesListDataSourceDelegate? { get set }
    var isFetchingMore: Bool { get }
    var hasMore: Bool { get }
    var fetchedObjectsCount: Int { get }
    var fetchedObjects: [ImagesListObject] { get }
    
    func objectsCount(at section: Int) -> Int
    func fetchedObject(at indexPath: IndexPath) -> FilesListObject?
    func indexPath(forObject object: FilesListObject) -> IndexPath?
    func fetchMore(startHandler: FetchStartBlock?, completionHandler: FetchCompletionBlock?)
}

extension ImageListsDataSourceProtocol {
    
    //For loading more images when scrool down
    func objectsCount(at section: Int) -> Int {
        if isFilesSection(section) {
            return fetchedObjectsCount
        } else if isSpinnerSection(section) {
            return isFetchingMore ? 1 : 0
        } else {
            return 0
        }
    }
    
    func isFilesSection(_ section: Int) -> Bool {
        return section == fileSectionIndex
    }
    
    func isSpinnerSection(_ section: Int) -> Bool {
        return section == spinnerSectionIndex
    }
    
    var spinnerSectionIndex: Int {
        return 1
    }
    
    var fileSectionIndex: Int {
        return 0
    }
    
    var sectionsCount: Int {
        return 2
    }
    
}

