//
//  MapUtils.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/27/22.
//

import Foundation
import CoreLocation
import SwiftUI

// https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#ECMAScript_.28JavaScript.2FActionScript.2C_etc..29
func transformCoordinate(_ latitude: Double, _ longitude: Double, withZoom zoom: CGFloat) -> (x: Int, y: Int) {
    let tileX = Int(floor((longitude + 180) / 360.0 * pow(2.0, Double(zoom))))
    let tileY = Int(floor((1 - log( tan( latitude * Double.pi / 180.0 ) + 1 / cos( latitude * Double.pi / 180.0 )) / Double.pi ) / 2 * pow(2.0, Double(zoom))))
    
    return (tileX, tileY)
}

func transformCoordinate(_ latitude: Double, _ longitude: Double, withZoom zoom: Int) -> (x: Int, y: Int) {
    transformCoordinate(latitude, longitude, withZoom: CGFloat(zoom))
}

func transformCoordinate(_ coord: CLLocationCoordinate2D, withZoom zoom: CGFloat) -> (x: Int, y: Int) {
    return transformCoordinate(coord.latitude, coord.longitude, withZoom: zoom)
}

func transformCoordinate(_ coord: CLLocationCoordinate2D, withZoom zoom: Int) -> (x: Int, y: Int) {
    return transformCoordinate(coord.latitude, coord.longitude, withZoom: CGFloat(zoom))
}

func tile2long(x: Int, z: CGFloat) -> Double {
    return (Double(x)/pow(2,Double(z))*360-180);
}

func tile2lat(y: Int, z: CGFloat) -> Double {
    let n = Double.pi-2*Double.pi*Double(y)/pow(2,Double(z));
    return (180/Double.pi*atan(0.5*(exp(n)-exp(-n))));
}

func tileBbox(_ tile: (x: Int, y: Int), withZoom z: CGFloat) -> (tl: CLLocationCoordinate2D, br: CLLocationCoordinate2D) {
    let tl = CLLocationCoordinate2D(latitude: tile2lat(y: tile.y, z: z), longitude: tile2long(x: tile.x, z: z))
    let br = CLLocationCoordinate2D(latitude: tile2lat(y: tile.y+1, z: z), longitude: tile2long(x: tile.x+1, z: z))
    return (tl, br)
}

func tileBbox(_ tile: (x: Int, y: Int), withZoom z: Int) -> (tl: CLLocationCoordinate2D, br: CLLocationCoordinate2D) {
    return tileBbox(tile, withZoom: CGFloat(z))
}

var zoom        = 9;
var topleft     = transformCoordinate(0, 0, withZoom: zoom)
var top_tile    = topleft.y
var left_tile   = topleft.x
var botright    = transformCoordinate(1, 1, withZoom: zoom)
var bottom_tile = botright.y
var right_tile  = botright.x
var width       = abs(left_tile - right_tile) + 1;
var height      = abs(top_tile - bottom_tile) + 1;

// total tiles
var total_tiles = width * height; // -> eg. 377

var TILESERVER_URL = "https://maptiles.geocaching.com/tile/{z}/{x}/{y}@2x.png"
var scaleFactor: CGFloat = 2

struct Tile: Hashable, Equatable {
    var x: Int
    var y: Int
    var z: Int
    func getImage() async throws -> (Bool, Image) {
        //let data = try await getData(url: URL(string: "https://tile.openstreetmap.org/\(z)/\(x)/\(y).png")!)
        let url = URL(string: TILESERVER_URL.replacingOccurrences(of: "{z}", with: "\(z)").replacingOccurrences(of: "{x}", with: "\(x)").replacingOccurrences(of: "{y}", with: "\(y)"))!
        //let data = try Data(contentsOf: url)
        let (_, data) = try await getData(url: url)
        let uiIm = UIImage(data: data, scale: scaleFactor)
        return (uiIm != nil, Image(uiImage: (uiIm ?? UIImage(systemName: "exclamationmark.triangle.fill")!)))
    }
}

func numTilesFor(_ topLeft: CLLocationCoordinate2D, _ bottomRight: CLLocationCoordinate2D, withZoom z: Int) -> (x: Int, y: Int) {
    let transformed1 = transformCoordinate(topLeft, withZoom: z)
    let transformed2 = transformCoordinate(bottomRight, withZoom: z)
    return (abs(transformed1.x - transformed2.x)+1, abs(transformed1.y - transformed2.y)+1)
}

func tilesFor(_ topLeft: CLLocationCoordinate2D, _ bottomRight: CLLocationCoordinate2D, withZoom z: CGFloat) -> [Tile] {
    let transformed1 = transformCoordinate(topLeft, withZoom: z)
    let transformed2 = transformCoordinate(bottomRight, withZoom: z)
    let minX = min(transformed1.x, transformed2.x)
    let minY = min(transformed1.y, transformed2.y)
    let maxX = max(transformed1.x, transformed2.x)
    let maxY = max(transformed1.y, transformed2.y)
    var tiles: [Tile] = []
    for x in minX...maxX {
        for y in minY...maxY {
            tiles.append(Tile(x: x, y: y, z: Int(round(z))))
        }
    }
    return tiles
}

func tilesFor(_ topLeft: CLLocationCoordinate2D, _ bottomRight: CLLocationCoordinate2D, withZoom z: Int) -> [Tile] {
    return tilesFor(topLeft, bottomRight, withZoom: CGFloat(z))
}

func findMaxZoom(_ topLeft: CLLocationCoordinate2D, _ bottomRight: CLLocationCoordinate2D, tileLimit l: Int) -> Int {
    for z in (0...19).reversed() {
        let nt = numTilesFor(topLeft, bottomRight, withZoom: z)
        if (nt.x * nt.y) <= l {
            return z
        }
    }
    return 0
}
