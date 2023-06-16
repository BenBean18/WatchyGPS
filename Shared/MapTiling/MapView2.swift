//
//  MapView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/27/22.
//

import SwiftUI
import SceneKit
import MapKit

// Find screen width and height, store
// Put desired point & radius in the center
// Tile outward until screen is filled
// Crop to fit

//func tilesFor(center: CLLocationCoordinate2D, screenWidth: Int, screenHeight: Int, tileSize: Int, withZoom z: Int) -> (tiles: [Tile], offset: (x: Int, y: Int), pos: (x: Int, y: Int), xy: (x: Int, y: Int)) {
//    let centerXY = transformCoordinate(center, withZoom: z)
//    let centerTile = Tile(x: centerXY.x, y: centerXY.y, z: z)
//    let centerTileBbox = tileBbox(centerXY, withZoom: z)
//    let tileLat = abs(centerTileBbox.tl.latitude - centerTileBbox.br.latitude)
//    let tileLon = abs(centerTileBbox.tl.longitude - centerTileBbox.br.longitude)
//    let posInTile: (x: Int, y: Int) = (Int(Double(center.longitude - centerTileBbox.tl.longitude) / tileLon * 256.0), Int(Double(center.latitude - centerTileBbox.br.latitude) / tileLat * 256.0))
//    // relative to center
//    var l = posInTile.x
//    var r = 256 - posInTile.x
//    var t = posInTile.y
//    var b = 256 - posInTile.y
//    print("1")
//    print(l, r, t, b)
//
//    var lc = centerTile.x
//    var rc = centerTile.x
//    var tc = centerTile.y
//    var bc = centerTile.y
//    while l+r < screenWidth+512 {
//        lc -= 1
//        l += 256
//        rc += 1
//        r += 256
//    }
//    while t+b < screenHeight+512 {
//        tc -= 1
//        t += 256
//        bc += 1
//        b += 256
//    }
//    print("2")
//    print(l, r, t, b)
//
//    var tiles: [Tile] = []
//    for x in lc...rc {
//        for y in tc...bc {
//            print(x, y)
//            tiles.append(Tile(x: x, y: y, z: z))
//        }
//    }
//    return (tiles, (centerTile.x - lc, centerTile.y - tc), posInTile, (rc-lc+1, bc-tc+1))
//}
//
//let m: Double = 1.0 / 111111.0

struct MapView2: View {
    @State var z: Int = 16
    @State var tiles: [Tile] = []
    @State var imArray: [[AnyView]] = []
    @State var tf: (tiles: [Tile], offset: (x: Int, y: Int), pos: (x: Int, y: Int), xy: (x: Int, y: Int))? = nil
    @State var bbox: (tl: CLLocationCoordinate2D, br: CLLocationCoordinate2D)? = nil
    @State var center = CLLocationCoordinate2D(latitude: 36.018511046147694, longitude: -78.9344629302171)
    var tl: CLLocationCoordinate2D {
        get {
            CLLocationCoordinate2D(latitude: center.latitude - 10000 * m, longitude: center.longitude - 10000 * m)
        }
    }
    var br: CLLocationCoordinate2D {
        get {
            CLLocationCoordinate2D(latitude: center.latitude + 10000 * m, longitude: center.longitude + 10000 * m)
        }
    }
    #if os(iOS)
    let screenSize = UIScreen.main.bounds.size
    #elseif os(watchOS)
    let screenSize = WKInterfaceDevice.current().screenBounds
    #endif
    
    func coordDeltaToLatLon(delta: (x: CGFloat, y: CGFloat)) -> (y: CGFloat, x: CGFloat) {
        let latRat = abs(bbox!.tl.latitude - bbox!.br.latitude) / screenSize.height
        let lonRat = abs(bbox!.tl.longitude - bbox!.br.longitude) / screenSize.width
        return (latRat * CGFloat(delta.y), lonRat * CGFloat(delta.x))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 0) {
                    ForEach(imArray.indices, id: \.self) { y in
                        HStack(spacing: 0) {
                            ForEach(imArray[y].indices, id: \.self) { x in
                                imArray[y][x]
                            }
                        }
                    }
                }
                .scaledToFill()
                .padding(.leading, -(256-(geometry.size.width-256)/2)-CGFloat(tf?.pos.x ?? 0)+128-((CGFloat(tf?.offset.x ?? 0)-CGFloat(1))*CGFloat(256)))
                .padding(.top, -(256-(geometry.size.height-256)/2)-(256-CGFloat(tf?.pos.y ?? 0)-128+((CGFloat(tf?.offset.y ?? 0)-CGFloat(1))*CGFloat(256))))
            }
            .gesture(
                DragGesture()
                    .onEnded {
                        gesture in
                        let delta = coordDeltaToLatLon(delta: (-gesture.translation.width, gesture.translation.height))
                        center = CLLocationCoordinate2D(latitude: center.latitude + delta.y, longitude: center.longitude + delta.x)
                    }
                    .onChanged { gesture in
                        let delta = coordDeltaToLatLon(delta: (-gesture.translation.width, gesture.translation.height))
                        let newCenter = CLLocationCoordinate2D(latitude: center.latitude + delta.y, longitude: center.longitude + delta.x)
                        withAnimation {
                            imArray = []
                            z = 18
                            tf = tilesFor(center: newCenter, screenWidth: Int(geometry.size.width), screenHeight: Int(geometry.size.height), tileSize: 512, withZoom: z)
                            tiles = tf!.tiles
                            print(tiles.count)
                            let tileXY = tf!.xy
                            for y in 0..<tileXY.y {
                                imArray.append([])
                                for _ in 0..<tileXY.x {
                                    imArray[y].append(AnyView(ProgressView().progressViewStyle(.circular)))
                                }
                            }
                            let sortedY = tiles.sorted { lhs, rhs in
                                lhs.y < rhs.y
                            }
                            let sortedX = tiles.sorted { lhs, rhs in
                                lhs.x < rhs.x
                            }
                            let tlb = tileBbox((sortedX[0].x, sortedY[0].y), withZoom: z)
                            let brb = tileBbox((sortedX[sortedX.count-1].x, sortedY[sortedY.count-1].y), withZoom: z)
                            bbox = (tlb.tl, brb.br)
                            for tile in tiles {
                                Task.init {
                                    print(tile.y, tile.x)
                                    let (status, im) = try await tile.getImage()
                                    imArray[tile.y - sortedY[0].y][tile.x - sortedX[0].x] = AnyView(im)
                                }
                            }
                        }
                    }
            )
            .onAppear {
                z = 18
                tf = tilesFor(center: center, screenWidth: Int(geometry.size.width), screenHeight: Int(geometry.size.height), tileSize: 512, withZoom: z)
                tiles = tf!.tiles
                print(tiles.count)
                let tileXY = tf!.xy
                for y in 0..<tileXY.y {
                    imArray.append([])
                    for _ in 0..<tileXY.x {
                        imArray[y].append(AnyView(ProgressView().progressViewStyle(.circular)))
                    }
                }
                let sortedY = tiles.sorted { lhs, rhs in
                    lhs.y < rhs.y
                }
                let sortedX = tiles.sorted { lhs, rhs in
                    lhs.x < rhs.x
                }
                let tlb = tileBbox((sortedX[0].x, sortedY[0].y), withZoom: z)
                let brb = tileBbox((sortedX[sortedX.count-1].x, sortedY[sortedY.count-1].y), withZoom: z)
                bbox = (tlb.tl, brb.br)
                for tile in tiles {
                    Task.init {
                        print(tile.y, tile.x)
                        let (status, im) = try await tile.getImage()
                        imArray[tile.y - sortedY[0].y][tile.x - sortedX[0].x] = AnyView(im)
                    }
                }
            }
        }
    }
}

struct MapView2_Previews: PreviewProvider {
    static var previews: some View {
        MapView2()
    }
}
