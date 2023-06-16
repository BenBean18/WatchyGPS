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

let TILE_SIZE: CGFloat = 256.0
var TILESERVER_MAX_Z: Int = 17

// https://www.hackingwithswift.com/example-code/language/how-to-split-an-array-into-chunks
extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
let MAX_PARALLEL_THREADS = 2

func tilesFor(center: CLLocationCoordinate2D, screenWidth: Int, screenHeight: Int, tileSize: Int, withZoom z: Int) -> (tiles: [Tile], offset: (x: Int, y: Int), pos: (x: Int, y: Int), xy: (x: Int, y: Int)) {
    let centerXY = transformCoordinate(center, withZoom: z)
    let centerTile = Tile(x: centerXY.x, y: centerXY.y, z: z)
    let centerTileBbox = tileBbox(centerXY, withZoom: z)
    let tileLat = abs(centerTileBbox.tl.latitude - centerTileBbox.br.latitude)
    let tileLon = abs(centerTileBbox.tl.longitude - centerTileBbox.br.longitude)
    let posInTile: (x: Int, y: Int) = (Int(Double(center.longitude - centerTileBbox.tl.longitude) / tileLon * Double(TILE_SIZE)), Int(Double(center.latitude - centerTileBbox.br.latitude) / tileLat * Double(TILE_SIZE)))
    // relative to center
    var l = posInTile.x
    var r = Int(TILE_SIZE) - posInTile.x
    var t = posInTile.y
    var b = Int(TILE_SIZE) - posInTile.y
    print("1")
    print(l, r, t, b)
    
    var lc = centerTile.x
    var rc = centerTile.x
    var tc = centerTile.y
    var bc = centerTile.y
    while l+r < screenWidth+512 {
        lc -= 1
        l += Int(TILE_SIZE)
        rc += 1
        r += Int(TILE_SIZE)
    }
    while t+b < screenHeight+512 {
        tc -= 1
        t += Int(TILE_SIZE)
        bc += 1
        b += Int(TILE_SIZE)
    }
    print("2")
    print(l, r, t, b)
    
    var tiles: [Tile] = []
    for x in lc...rc {
        for y in tc...bc {
            print(x, y)
            tiles.append(Tile(x: x, y: y, z: z))
        }
    }
    return (tiles, (centerTile.x - lc, centerTile.y - tc), posInTile, (rc-lc+1, bc-tc+1))
}

let m: Double = 1.0 / 111111.0

struct MapTileAnnotation: Identifiable {
    var id = UUID()
    var coords: CLLocationCoordinate2D
    var data: Any? = nil
}

struct MapView3<T>: View where T : View {
    var annotationItems: [MapTileAnnotation]
    @Binding var z: CGFloat
    @Binding var center: CLLocationCoordinate2D
    @Binding var userLocation: CLLocation?
    @Binding var userHeading: CLHeading?
    var annotationContent: (MapTileAnnotation) -> T
    @State var oldZ: CGFloat = 0
    @State var tiles: [Tile] = []
    @State var imArray: [[AnyView]] = []
    @State var tf: (tiles: [Tile], offset: (x: Int, y: Int), pos: (x: Int, y: Int), xy: (x: Int, y: Int))? = nil
    @State var bbox: (tl: CLLocationCoordinate2D, br: CLLocationCoordinate2D)? = nil
    @State var previouslyLoadedTiles: [Tile : Image] = [:]
    @State var refresh: Bool = false
    @State var loadingTiles: Set<Tile> = []
    @State var mapProxy: GeometryProxy? = nil
    @State var tltg: GeometryProxy? = nil
    @State var brtg: GeometryProxy? = nil
    @State var appeared: Bool = true
    @State var anchor: UnitPoint = UnitPoint.center
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
        let latRat = abs(bbox!.tl.latitude - bbox!.br.latitude) / mapProxy!.size.height
        let lonRat = abs(bbox!.tl.longitude - bbox!.br.longitude) / mapProxy!.size.width
        return (latRat * CGFloat(delta.y) * 1/subZoom, lonRat * CGFloat(delta.x) * 1/subZoom)
    }
    
    func latLonToScreenPos(coord: CLLocationCoordinate2D) -> (y: CGFloat, x: CGFloat, onscreen: Bool) {
        let frame: CoordinateSpace = .named("Screen")
        if bbox != nil && tltg != nil && brtg != nil {
//            let latRat = screenSize.height / abs(bbox!.tl.latitude - bbox!.br.latitude)
//            let lonRat = screenSize.width / abs(bbox!.tl.longitude - bbox!.br.longitude)
//            return (latRat * CGFloat(coord.latitude - bbox!.br.latitude), lonRat * CGFloat(coord.longitude - bbox!.tl.longitude))
            let y = (coord.latitude - bbox!.tl.latitude) * (brtg!.frame(in: frame).maxY - tltg!.frame(in: frame).minY) / (bbox!.br.latitude - bbox!.tl.latitude) + tltg!.frame(in: frame).minY
            let x = (coord.longitude - bbox!.tl.longitude) * (brtg!.frame(in: frame).maxX - tltg!.frame(in: frame).minX) / (bbox!.br.longitude - bbox!.tl.longitude) + tltg!.frame(in: frame).minX
            // print("xyz", x, y, "xmaxmin", brtg!.frame(in: frame).maxX, tltg!.frame(in: frame).minX, "ymaxmin", brtg!.frame(in: frame).maxY, tltg!.frame(in: frame).minY, "latmaxmin", bbox!.tl.latitude, bbox!.br.latitude)
            if y > brtg!.frame(in: frame).maxY || y < tltg!.frame(in: frame).minY || x > brtg!.frame(in: frame).maxX || x < tltg!.frame(in: frame).minX {
                return (0, 0, false)
            }
            return (y, x, true)
        } else {
            return (0, 0, false)
        }
    }
    
    @MainActor
    func update(newCenter: CLLocationCoordinate2D, geometry: GeometryProxy, zoom: CGFloat) {
        let z = Int(round(zoom)) <= TILESERVER_MAX_Z ? Int(round(zoom)) : TILESERVER_MAX_Z
        imArray = []
        tf = tilesFor(center: newCenter, screenWidth: Int(geometry.size.width), screenHeight: Int(geometry.size.height), tileSize: Int(TILE_SIZE), withZoom: z)
        tiles = tf!.tiles
        print(tiles.count)
        let tileXY = tf!.xy
        print(previouslyLoadedTiles.keys)
        let sortedY = tiles.sorted { lhs, rhs in
            lhs.y < rhs.y
        }
        let sortedX = tiles.sorted { lhs, rhs in
            lhs.x < rhs.x
        }
        for y in 0..<tileXY.y {
            imArray.append([])
            for x in 0..<tileXY.x {
                let tile = Tile(x: x+sortedX[0].x, y: y+sortedY[0].y, z: z)
                if previouslyLoadedTiles.keys.contains(tile) {
                    imArray[y].append(AnyView(previouslyLoadedTiles[tile]!))
                } else {
                    print("Need tile \(tile)")
                    imArray[y].append(AnyView(ProgressView().progressViewStyle(.circular)))
                }
            }
        }
        let tlb = tileBbox((sortedX[0].x, sortedY[0].y), withZoom: z)
        let brb = tileBbox((sortedX[sortedX.count-1].x, sortedY[sortedY.count-1].y), withZoom: z)
        bbox = (tlb.tl, brb.br)
        let chunkedTiles = tiles.chunked(into: tiles.count / MAX_PARALLEL_THREADS)
        for theseTiles in chunkedTiles {
            Task.init {
                let oldTiles = tiles
                for tile in theseTiles {
                    if !previouslyLoadedTiles.keys.contains(tile) && !loadingTiles.contains(tile) {
                        if tiles.contains(tile) {
                            print(tile.y, tile.x)
                            loadingTiles.insert(tile)
                            let (status, im) = try await tile.getImage()
                            if status == true {
                                print("Request succeeded for tile \(tile)")
                                previouslyLoadedTiles[tile] = im
                                refresh.toggle()
                                if tiles == oldTiles {
                                    imArray[tile.y - sortedY[0].y][tile.x - sortedX[0].x] = AnyView(im.resizable().scaledToFit().aspectRatio(contentMode: .fit))
                                }
                                loadingTiles.remove(tile)
                            } else {
                                print("Request failed for tile \(tile)")
                                loadingTiles.remove(tile)
                            }
                        }
                    }
                }
            }
        }
    }
    
    var subZoom: CGFloat {
        get {
            if Int(round(z)) <= TILESERVER_MAX_Z {
                return pow(2, z - round(z))
            } else {
                return pow(2, z - CGFloat(TILESERVER_MAX_Z))
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            Group {
                ZStack {
                    VStack(spacing: 0) {
                        ForEach(imArray.indices, id: \.self) { y in
                            HStack(spacing: 0) {
                                ForEach(imArray[y].indices, id: \.self) { x in
                                    imArray[y][x]
                                        .frame(width: TILE_SIZE, height: TILE_SIZE)
                                        .background(GeometryReader {
                                            g in Color.clear.onAppear {
                                                print("upd")
                                                if y == 0 && x == 0 {
                                                    tltg = g
                                                }
                                                if y == imArray.count-1 && x == imArray[y].count-1 {
                                                    brtg = g
                                                }
                                            }.onChange(of: tiles, perform: { _ in
                                                print("upd")
                                                if y == 0 && x == 0 {
                                                    tltg = g
                                                }
                                                if y == imArray.count-1 && x == imArray[y].count-1 {
                                                    brtg = g
                                                }
                                            })
                                        })
                                        .onTapGesture {
                                             let sortedY = tf!.tiles.sorted { lhs, rhs in
                                                 lhs.y < rhs.y
                                             }
                                             let sortedX = tf!.tiles.sorted { lhs, rhs in
                                                 lhs.x < rhs.x
                                             }
                                             print("Removing \(Tile(x: sortedX[0].x+x, y: sortedY[0].y+y, z: Int(round(z)))) from loadingTiles")
                                             loadingTiles.remove(Tile(x: sortedX[0].x+x, y: sortedY[0].y+y, z: Int(round(z))))
                                        }
                                }
                            }
                        }
                    }
                    .scaledToFill()
//                    .padding(.leading, -(TILE_SIZE-(geometry.size.width-TILE_SIZE)/2)-CGFloat(tf?.pos.x ?? 0)+128-((CGFloat(tf?.offset.x ?? 0)-CGFloat(1))*CGFloat(TILE_SIZE)))
//                    .padding(.top, -(TILE_SIZE-(geometry.size.height-TILE_SIZE)/2)-(TILE_SIZE-CGFloat(tf?.pos.y ?? 0)-128+((CGFloat(tf?.offset.y ?? 0)-CGFloat(1))*CGFloat(TILE_SIZE))))
                    .background(GeometryReader {
                        geometry in
                        Color.clear
                            .onAppear {
                                print("Proxy")
                                mapProxy = geometry
                            }
                            .coordinateSpace(name: "Map")
                    })
                }
                .offset(x: -(TILE_SIZE-(geometry.size.width-TILE_SIZE)/2)-CGFloat(tf?.pos.x ?? 0)+TILE_SIZE/2-((CGFloat(tf?.offset.x ?? 0)-CGFloat(1))*CGFloat(TILE_SIZE)), y: -(TILE_SIZE-(geometry.size.height-TILE_SIZE)/2)-(TILE_SIZE-CGFloat(tf?.pos.y ?? 0)-TILE_SIZE/2+((CGFloat(tf?.offset.y ?? 0)-CGFloat(1))*CGFloat(TILE_SIZE))))
                .scaleEffect(subZoom, anchor: anchor)
//                .offset(x: (-(TILE_SIZE-(geometry.size.width*(Int(round(z)) > TILESERVER_MAX_Z ? 1/subZoom : 1)-TILE_SIZE)/2)-CGFloat(tf?.pos.x ?? 0)+TILE_SIZE/2-((CGFloat(tf?.offset.x ?? 0)-CGFloat(1))*CGFloat(TILE_SIZE)))*(Int(round(z)) > TILESERVER_MAX_Z ? subZoom : 1), y: (-(TILE_SIZE-(geometry.size.height*(Int(round(z)) > TILESERVER_MAX_Z ? 1/subZoom : 1)-TILE_SIZE)/2)-(TILE_SIZE-CGFloat(tf?.pos.y ?? 0)-TILE_SIZE/2+((CGFloat(tf?.offset.y ?? 0)-CGFloat(1))*CGFloat(TILE_SIZE))))*(Int(round(z)) > TILESERVER_MAX_Z ? subZoom : 1))
//                .offset(x: Int(round(z)) > TILESERVER_MAX_Z ? 0 : -(TILE_SIZE-(geometry.size.width-TILE_SIZE)/2)-CGFloat(tf?.pos.x ?? 0)+TILE_SIZE/2-((CGFloat(tf?.offset.x ?? 0)-CGFloat(1))*CGFloat(TILE_SIZE)), y: Int(round(z)) > TILESERVER_MAX_Z ? 0 : -(TILE_SIZE-(geometry.size.height-TILE_SIZE)/2)-(TILE_SIZE-CGFloat(tf?.pos.y ?? 0)-TILE_SIZE/2+((CGFloat(tf?.offset.y ?? 0)-CGFloat(1))*CGFloat(TILE_SIZE))))
                GeometryReader { geo in
                    ZStack {
                        ForEach(annotationItems, id: \.id) { item in
                            if latLonToScreenPos(coord: item.coords).onscreen {
                                annotationContent(item)
                                    .position(x: latLonToScreenPos(coord: item.coords).x, y: latLonToScreenPos(coord: item.coords).y)
                            }
                        }
                        if userLocation != nil && userHeading != nil && appeared {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.75))
                                    .frame(width: 32, height: 32)
                                Circle()
                                    .stroke(Color.white, lineWidth: 3)
                                    .frame(width: 32, height: 32)
                                Capsule()
                                    .frame(width: 3, height: 12)
                                    .padding(.bottom, 12)
                                    .rotationEffect(Angle.degrees(userHeading!.trueHeading))
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .drawingGroup()
                            .scaleEffect(0.75)
                            .position(x: latLonToScreenPos(coord: userLocation!.coordinate).x, y: latLonToScreenPos(coord: userLocation!.coordinate).y)
                        }
//                        Circle()
//                            .frame(width: 10, height: 10)
//                            .foregroundColor(.blue)
//                            .position(x: latLonToScreenPos(coord: CLLocationCoordinate2D(latitude: 36.003565, longitude: -78.933730)).x, y: latLonToScreenPos(coord: CLLocationCoordinate2D(latitude: 36.003565, longitude: -78.933730)).y)
//                            .onChange(of: tiles, perform: { _ in
//                                print("proxy \(geo.frame(in: .named("Map")))")
//                                print("xy \(latLonToScreenPos(coord: center))")
//                            })
                    }
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .coordinateSpace(name: "Screen")
                }
                .edgesIgnoringSafeArea(.all)
            }
            #if !os(watchOS)
            .gesture(
                MagnificationGesture()
                    .onChanged { amount in
                        let newZ = oldZ + log2(amount)
//                        if Int(round(newZ)) > TILESERVER_MAX_Z+3 {
//                            newZ = CGFloat(TILESERVER_MAX_Z+3)
//                        }
//                        if newZ < 0 {
//                            newZ = 0
//                        }
                        z = newZ
                        update(newCenter: center, geometry: geometry, zoom: newZ)
                        anchor = UnitPoint(x: geometry.frame(in: .named("Map")).midX / (mapProxy?.size.width ?? 1), y: geometry.frame(in: .named("Map")).midY / (mapProxy?.size.height ?? 1))
                    }
                    .onEnded { amount in
                        //z = round(z) > CGFloat(TILESERVER_MAX_Z) ? z : round(z)
                        oldZ = z
//                        var newZ = CGFloat(z) + log2(amount)
//                        if newZ > 18 {
//                            newZ = 18
//                        }
//                        if newZ < 0 {
//                            newZ = 0
//                        }
//                        z = newZ
                        update(newCenter: center, geometry: geometry, zoom: z)
                    }
            )
            #else
            // https://www.hackingwithswift.com/quick-start/swiftui/how-to-read-the-digital-crown-on-watchos-using-digitalcrownrotation
            .focusable()
            .digitalCrownRotation(Binding<Double>(get: { return Double(z) }, set: { newZ in
                z = newZ
                update(newCenter: center, geometry: geometry, zoom: z)
                anchor = UnitPoint(x: geometry.frame(in: .named("Map")).midX / (mapProxy?.size.width ?? 1), y: geometry.frame(in: .named("Map")).midY / (mapProxy?.size.height ?? 1))
            }), from: 0, through: Double(TILESERVER_MAX_Z+3), by: 1, sensitivity: .low, isContinuous: false, isHapticFeedbackEnabled: true)
            #endif
            .onChange(of: TILESERVER_URL, perform: { _ in
                previouslyLoadedTiles = [:]
            })
            .onChange(of: center, perform: { _ in
                 update(newCenter: center, geometry: geometry, zoom: z)
            })
            .simultaneousGesture(
                DragGesture()
                    .onEnded {
                        gesture in
                        let delta = coordDeltaToLatLon(delta: (-gesture.translation.width, gesture.translation.height))
                        center = CLLocationCoordinate2D(latitude: center.latitude + delta.y, longitude: center.longitude + delta.x)
                        update(newCenter: center, geometry: geometry, zoom: z)
                    }
                    .onChanged { gesture in
                        let delta = coordDeltaToLatLon(delta: (-gesture.translation.width, gesture.translation.height))
                        let newCenter = CLLocationCoordinate2D(latitude: center.latitude + delta.y, longitude: center.longitude + delta.x)
                        print("Updating")
                        update(newCenter: newCenter, geometry: geometry, zoom: z)
                        anchor = UnitPoint(x: geometry.frame(in: .named("Map")).midX / (mapProxy?.size.width ?? 1), y: geometry.frame(in: .named("Map")).midY / (mapProxy?.size.height ?? 1))
//                        imArray = []
//                        tf = tilesFor(center: newCenter, screenWidth: Int(geometry.size.width), screenHeight: Int(geometry.size.height), tileSize: 256, withZoom: z)
//                        tiles = tf!.tiles
//                        print(tiles.count)
//                        let tileXY = tf!.xy
//                        print(previouslyLoadedTiles.keys)
//                        let sortedY = tiles.sorted { lhs, rhs in
//                            lhs.y < rhs.y
//                        }
//                        let sortedX = tiles.sorted { lhs, rhs in
//                            lhs.x < rhs.x
//                        }
//                        for y in 0..<tileXY.y {
//                            imArray.append([])
//                            for x in 0..<tileXY.x {
//                                let tile = Tile(x: x+sortedX[0].x, y: y+sortedY[0].y, z: z)
//                                if previouslyLoadedTiles.keys.contains(tile) {
//                                    imArray[y].append(AnyView(previouslyLoadedTiles[tile]!))
//                                } else {
//                                    print("Need tile \(tile)")
//                                    imArray[y]  .append(AnyView(ProgressView().progressViewStyle(.circular)))
//                                }
//                            }
//                        }
//                        let tlb = tileBbox((sortedX[0].x, sortedY[0].y), withZoom: z)
//                        let brb = tileBbox((sortedX[sortedX.count-1].x, sortedY[sortedY.count-1].y), withZoom: z)
//                        bbox = (tlb.tl, brb.br)
//                        let chunkedTiles = tiles.chunked(into: tiles.count / MAX_PARALLEL_THREADS)
//                        var loadingTiles: Set<Tile> = []
//                        for theseTiles in chunkedTiles {
//                            Task.init {
//                                let oldTiles = tiles
//                                for tile in theseTiles {
//                                    if !previouslyLoadedTiles.keys.contains(tile) && !loadingTiles.contains(tile) {
//                                        if tiles.contains(tile) {
//                                            print(tile.y, tile.x)
//                                            loadingTiles.insert(tile)
//                                            let (status, im) = try await tile.getImage()
//                                            if status == true {
//                                                previouslyLoadedTiles[tile] = im
//                                                refresh.toggle()
//                                                if tiles == oldTiles {
//                                                    imArray[tile.y - sortedY[0].y][tile.x - sortedX[0].x] = AnyView(im)
//                                                }
//                                                loadingTiles.remove(tile)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
                    }
            )
            .onDisappear {
                appeared = false
            }
            .onAppear {
                oldZ = z
                appeared = true
                update(newCenter: center, geometry: geometry, zoom: z)
//                tf = tilesFor(center: center, screenWidth: Int(geometry.size.width), screenHeight: Int(geometry.size.height), tileSize: Int(TILE_SIZE), withZoom: Int(round(z)))
//                tiles = tf!.tiles
//                print(tiles.count)
//                let tileXY = tf!.xy
//                for y in 0..<tileXY.y {
//                    imArray.append([])
//                    for _ in 0..<tileXY.x {
//                        imArray[y].append(AnyView(ProgressView().progressViewStyle(.circular)))
//                    }
//                }
//                let sortedY = tiles.sorted { lhs, rhs in
//                    lhs.y < rhs.y
//                }
//                let sortedX = tiles.sorted { lhs, rhs in
//                    lhs.x < rhs.x
//                }
//                let tlb = tileBbox((sortedX[0].x, sortedY[0].y), withZoom: Int(round(z)))
//                let brb = tileBbox((sortedX[sortedX.count-1].x, sortedY[sortedY.count-1].y), withZoom: Int(round(z)))
//                bbox = (tlb.tl, brb.br)
//                let chunkedTiles = tiles.chunked(into: tiles.count / MAX_PARALLEL_THREADS)
//                for theseTiles in chunkedTiles {
//                    Task.init {
//                        for tile in theseTiles {
//                            if !previouslyLoadedTiles.keys.contains(tile) {
//                                print(tile.y, tile.x)
//                                let (_, im) = try await tile.getImage()
//                                previouslyLoadedTiles[tile] = im
//                                imArray[tile.y - sortedY[0].y][tile.x - sortedX[0].x] = AnyView(im.resizable().scaledToFit().aspectRatio(contentMode: .fit))
//                            }
//                        }
//                    }
//                }
            }
        }
    }
}

struct MapView3_Previews: PreviewProvider {
    static var previews: some View {
        MapView3(annotationItems: [MapTileAnnotation(coords: CLLocationCoordinate2D(), data: GeocacheDetailView().cache)], z: .constant(16), center: .constant(CLLocationCoordinate2D()), userLocation: .constant(CLLocation()), userHeading: .constant(nil), annotationContent: { _ in EmptyView() })
    }
}
