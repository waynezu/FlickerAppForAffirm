import Foundation

class Dispatcher: NSObject {

    public static func dispatchAsync(_ function: StaticString = #function, file: StaticString = #file, line: UInt = #line, queue: DispatchQueue, block: @escaping () -> Void) {
    }
    
    public static func dispatchAsyncMain(_ function: StaticString = #function, file: StaticString = #file, line: UInt = #line, block: @escaping () -> Void) {
    }
    
    public static func dispatchSync(_ function: StaticString = #function, file: StaticString = #file, line: UInt = #line, queue: DispatchQueue, block: () -> Void) {
    }
    
    public static func dispatchSyncMain(_ function: StaticString = #function, file: StaticString = #file, line: UInt = #line, block: () -> Void) {
    }
    
}
