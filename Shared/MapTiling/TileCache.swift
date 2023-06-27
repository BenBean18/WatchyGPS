//
//  TileCache.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 6/26/23.
//

import Foundation
import UIKit

// https://www.hackingwithswift.com/books/ios-swiftui/writing-data-to-the-documents-directory
func getDocumentsDirectory() -> URL {
    // find all possible documents directories for this user
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)

    // just send back the first one, which ought to be the only one
    return paths[0]
}

// https://www.hackingwithswift.com/example-code/strings/how-to-convert-a-string-to-a-safe-format-for-url-slugs-and-filenames
extension String {
    private static let slugSafeCharacters = CharacterSet(charactersIn: "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz-_")

    public func convertedToSlug() -> String {
        if let latin = self.applyingTransform(StringTransform("Any-Latin; Latin-ASCII; Lower;"), reverse: false) {
            let urlComponents = latin.components(separatedBy: String.slugSafeCharacters.inverted)
            let result = urlComponents.filter { $0 != "" }.joined(separator: "-")

            if result.count > 0 {
                return result
            }
        }

        return "invalid-filename"
    }
}

// Consider storing the image within the Tile struct itself
// Makes stuff easier
// (never mind, not really since tiles get overwritten when the map moves)
class TileCache {
    static let shared = TileCache()
    
    let documentsDirectory: URL
    
    private init() {
        documentsDirectory = getDocumentsDirectory()
    }
    
    func addTileToCache(tile: Tile, image: UIImage) {
        let directory = documentsDirectory.appendingPathComponent("tiles/\(MAP_PROVIDER.name.convertedToSlug())/\(tile.z)", isDirectory: true)
        let fileURL = directory.appendingPathComponent("\(tile.x)-\(tile.y).png")
        do {
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true, attributes: nil)
        } catch let error as NSError {
            print("Directory creation failed: \(error)")
        }
        do {
            try image.pngData()?.write(to: fileURL)
        } catch {
            print("Failed to cache image to \(fileURL): \(error)")
        }
    }
    
    func retrieveTileFromCache(tile: Tile) -> UIImage? {
        let fileURL = documentsDirectory.appendingPathComponent("tiles/\(MAP_PROVIDER.name.convertedToSlug())/\(tile.z)/\(tile.x)-\(tile.y).png")
        do {
            return try UIImage(data: Data(contentsOf: fileURL), scale: MAP_PROVIDER.scaleFactor)!
        } catch {
            return nil
        }
    }
    
    func clearTileCache() -> Bool {
        do {
            try FileManager.default.removeItem(at: documentsDirectory.appendingPathComponent("tiles", isDirectory: true))
            print("Cache cleared")
            return true
        } catch {
            print("Failed to clear cache: \(error)")
            return false
        }
    }
}
