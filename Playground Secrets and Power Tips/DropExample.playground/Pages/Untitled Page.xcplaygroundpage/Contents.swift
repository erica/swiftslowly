//: Playground - noun: a place where people can play

import Cocoa
import XCPlayground

public extension String {
    public var ns: NSString {return self as NSString}
}

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true
//NSApplication.sharedApplication().setActivationPolicy(.Regular)

public let DroppedNotification = "DroppedNotification"
public class DropWindow : NSWindow, XCPlaygroundLiveViewable {
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func playgroundLiveViewRepresentation() -> XCPlayground.XCPlaygroundLiveViewRepresentation {
        guard let view = contentView else {fatalError("oops")}
        return .View(view)
    }
    
    override public init(
        contentRect: NSRect,
        styleMask aStyle: Int,
                  backing bufferingType: NSBackingStoreType,
                          `defer` flag: Bool) {
        super.init(
            contentRect: contentRect,
            styleMask: aStyle,
            backing: bufferingType,
            defer: flag)
    }
    
    convenience public init?(title: String = "Drop Here",
                       draggedTypes: [String] = [NSFilenamesPboardType]) {
        self.init(contentRect: CGRectMake(0, 100, 200, 200),
                  styleMask: NSTitledWindowMask,
                  backing: .Buffered,
                  defer: false)
        self.registerForDraggedTypes(draggedTypes)
        self.title = title
        self.level = 7
    }
    
    public func draggingEntered(
        sender: NSDraggingInfo!) -> NSDragOperation {
        return NSDragOperation.Copy
    }
    public func draggingUpdated(
        sender: NSDraggingInfo!) -> NSDragOperation {
        return NSDragOperation.Copy
    }
    
    public func performDragOperation(sender: NSDraggingInfo!) {
        let pboard = sender.draggingPasteboard()
        let note = NSNotification(
            name: DroppedNotification, object: pboard)
        NSNotificationCenter.defaultCenter().postNotification(note)
    }
}


NSNotificationCenter.defaultCenter()
    .addObserverForName(DroppedNotification,
        object: nil, queue: NSOperationQueue.mainQueue()) {
            note in
            guard let pasteboard =
                note.object as? NSPasteboard else {return}
            guard let paths: [String] = pasteboard
                .propertyListForType(NSFilenamesPboardType)
                as? [String] else {return}
            
            print("Word Count")
            for path in paths {
                guard let string =
                    try? String(contentsOfFile: path) else {continue}
                print(path.ns.lastPathComponent, ":", string.ns.length)
            }
}

guard let dropWindow = DropWindow(
    title: "Drop Files",
    draggedTypes: [NSFilenamesPboardType]) else {
        fatalError("Could not construct window")
}

dropWindow.contentView?.wantsLayer = true
dropWindow.contentView?.layer?.backgroundColor = NSColor.redColor().CGColor


XCPlaygroundPage.currentPage.liveView = dropWindow.contentView
