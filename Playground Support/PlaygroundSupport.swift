/*
  ericasadun.com
  Playground Support: Add to module in same workspace as the playground
*/

import Foundation

// Convenience
public let fileManager = NSFileManager.defaultManager()

//------------------------------------------------------------------------------
// MARK: Process Info
// Return information about the playground process and the environment
// it is running within
//------------------------------------------------------------------------------

// Access the playground's process info
public let processInfo = NSProcessInfo.processInfo()

// The playground's environmental variables
public let processEnvironment = processInfo.environment

// Keys in the environment dictionary for quick reference
public let environmentKeys = NSProcessInfo.processInfo().environment.keys.array

// Playground name (Used later to create a private documents folder)
public let playgroundName : String = (processEnvironment["PLAYGROUND_NAME"] ?? NSProcessInfo.processInfo().processName) as! String

// Path to the playground's sandbox container
#if os(iOS)
    public let playgroundContainerPath : String = (processEnvironment["PLAYGROUND_SANDBOX_CONTAINER_PATH"] ?? "?") as! String
    #else
    public let playgroundContainerPath : String = NSHomeDirectory().stringByDeletingLastPathComponent
#endif

//------------------------------------------------------------------------------
// MARK: Application
// Return information about the pseudo-app that the playground builds/executes
// Note: I'd like a real-world path to Resources (path-to-playground/Resources)
// but I don't think that's going to happen with sandboxing enabled
//------------------------------------------------------------------------------

// Path to the playground's bundle and resources
// At this time, they are identical on iOS (but not OS X)
public let bundlePath = NSBundle.mainBundle().bundlePath
public let resourcePath = NSBundle.mainBundle().resourcePath ?? bundlePath

// Bundle contents (currently only working on iOS)
public let bundleContents = fileManager.contentsOfDirectoryAtPath(bundlePath, error: nil) ?? []

// Resource contents (currently only working on iOS)
public let resourceContents = fileManager.contentsOfDirectoryAtPath(resourcePath, error: nil) ?? []

// The playground's executable inside the generated app
public let executablePath = NSBundle.mainBundle().executablePath

// Name of the playground's app
public let appName = bundlePath.lastPathComponent

// Access to the bundle's Info.plist dictionary
public let infoDictionary = NSBundle.mainBundle().infoDictionary

//------------------------------------------------------------------------------
// MARK: Shared Data Folder
// The shared playground data in the user Documents foler
//------------------------------------------------------------------------------

// The Shared Playground Data folder OUTSIDE THE SANDBOX
public let sharedDataFolder = (processEnvironment["PLAYGROUND_SHARED_DATA_FOLDER"] ?? "~/Documents/Shared Playground Data") as! String

//------------------------------------------------------------------------------
// MARK: Documents
// Return paths to the playground's documents folder
//------------------------------------------------------------------------------

#if os (iOS)
// The Shared Resources Folder for the simulator
// Typically ~/Library/Application Support/iPhone Simulator
public let sharedResourcesFolder = (processEnvironment["IPHONE_SHARED_RESOURCES_DIRECTORY"] ?? "?") as! String
#endif

// Sandbox root
public let homeFolder = NSHomeDirectory()

// From the root to the documents folder in the playground's sandbox
public let documentsFolder = NSHomeDirectory().stringByAppendingPathComponent("Documents")

// The shared data within the documents in the sandbox
public let playgroundDocumentsFolder = documentsFolder.stringByAppendingPathComponent("Shared Playground Data")

//------------------------------------------------------------------------------
// MARK: Custom Subfolder
// A custom subfolder to store this playground's data
// (This is not a default behavior, but meant to keep the
// shared documents folder cleaner)
//------------------------------------------------------------------------------

// From the shared data into a playground-named subfolder
public let myDocumentsFolder = playgroundDocumentsFolder.stringByAppendingPathComponent(playgroundName)

/// Create a playground-named subfolder in the shared playground data folder
public func EstablishMyDocumentsFolder() -> Bool {
    return fileManager.createDirectoryAtPath(myDocumentsFolder, withIntermediateDirectories: true, attributes: nil, error: nil)
}

/// Return contents of a custom playground-named subfolder
public func ContentsOfMyDocumentsFolder() -> [AnyObject]? {
    return fileManager.contentsOfDirectoryAtPath(myDocumentsFolder, error: nil)
}