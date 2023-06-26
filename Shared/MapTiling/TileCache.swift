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
        let fileURL = documentsDirectory.appendingPathExtension("\(MAP_PROVIDER.name.convertedToSlug())/\(tile.z)/\(tile.x)-\(tile.y).png")
        do {
            try image.pngData()?.write(to: fileURL)
        } catch {
            print("Failed to cache image")
        }
    }
    
    func retrieveTileFromCache(tile: Tile) -> UIImage {
        let fileURL = documentsDirectory.appendingPathExtension("\(MAP_PROVIDER.name.convertedToSlug())/\(tile.z)/\(tile.x)-\(tile.y).png")
        var uiImage: UIImage = UIImage(systemName: "exclamationmark.triangle.fill")!
        do {
            uiImage = try UIImage(data: Data(contentsOf: fileURL))!
        } catch {
            // do nothing, image is already the default /!\
        }
        return uiImage
    }
}
