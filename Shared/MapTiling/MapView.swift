//
//  MapView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/27/22.
//

import SwiftUI
import SceneKit
import MapKit

//let m: Double = 1.0 / 111111.0
//
//let center = CLLocationCoordinate2D(latitude: 36.019148, longitude: -78.934298)
//let tl = CLLocationCoordinate2D(latitude: center.latitude - 10000 * m, longitude: center.longitude - 10000 * m)
//let br = CLLocationCoordinate2D(latitude: center.latitude + 10000 * m, longitude: center.longitude + 10000 * m)
//var maxTiles = 16

//struct MapView: View {
//    @State var z: Int = 0
//    @State var tiles: [Tile] = []
//    @State var imArray: [[AnyView]] = []
//    @State var bbox: (tl: CLLocationCoordinate2D, br: CLLocationCoordinate2D)? = nil
//
//    func getRatio() -> CGSize {
//        return CGSize(width: abs(tl.longitude-br.longitude)/abs((bbox?.tl.longitude ?? 1)-(bbox?.br.longitude ?? 0)), height: abs(tl.latitude-br.latitude)/abs((bbox?.tl.latitude ?? 1)-(bbox?.br.latitude ?? 0)))
//    }
//
//    func leftPadding(_ g : GeometryProxy) -> CGFloat {
//        let bbl = abs((bbox?.tl.longitude ?? 1)-(bbox?.br.longitude ?? 0))
//        return -(abs(tl.longitude - (bbox?.tl.longitude ?? 0))/bbl) * g.size.width
//    }
//
//    func rightPadding(_ g : GeometryProxy) -> CGFloat {
//        let bbl = abs((bbox?.tl.longitude ?? 1)-(bbox?.br.longitude ?? 0))
//        return -(abs(br.longitude - (bbox?.br.longitude ?? 0))/bbl) * g.size.width
//    }
//
//    func topPadding(_ g : GeometryProxy) -> CGFloat {
//        let bbl = abs((bbox?.tl.latitude ?? 1)-(bbox?.br.latitude ?? 0))
//        let bot = bbox?.br.latitude ?? 0
//        let ratio = (center.latitude-bot) / bbl
//        let z = ratio - 0.5
//        return z * g.size.height
//    }
//
//    func bottomPadding(_ g : GeometryProxy) -> CGFloat {
//        let bbl = abs((bbox?.tl.latitude ?? 1)-(bbox?.br.latitude ?? 0))
//        return (abs(br.latitude - (bbox?.br.latitude ?? 0))/bbl) * g.size.height
//    }
//
//    var body: some View {
//        GeometryReader { geometry in
//            ZStack {
//                VStack(spacing: 0) {
//                    ForEach(imArray.indices, id: \.self) { y in
//                        HStack(spacing: 0) {
//                            ForEach(imArray[y].indices, id: \.self) { x in
//                                imArray[y][x]
//                            }
//                        }
//                    }
//                }
//                .padding(.leading, leftPadding(geometry))
////                .padding(.trailing, rightPadding(geometry))
//                .padding(.top, topPadding(geometry))
////                .padding(.bottom, bottomPadding(geometry))
////                .aspectRatio(getRatio(), contentMode: .fill)
//                .scaledToFill()
//                .frame(width: geometry.size.width, height: geometry.size.height)
//Circle()
//                    .frame(width: 10, height: 10)
//                Text("\(imArray.first?.count ?? 0)x\(imArray.count)@\(z)\n\(bbox?.tl.latitude ?? 0),\(bbox?.tl.longitude ?? 0)\n\(bbox?.br.latitude ?? 0),\(bbox?.br.longitude ?? 0)")
//                    .foregroundColor(.black)
//                    .font(.footnote)
//                    .padding()
//            }
//        }
//        .onAppear {
//            z = findMaxZoom(tl, br, tileLimit: maxTiles)
//            tiles = tilesFor(tl, br, withZoom: z)
//            print(tiles.count)
//            let tileXY = numTilesFor(tl, br, withZoom: z)
//            for y in 0..<tileXY.y {
//                imArray.append([])
//                for _ in 0..<tileXY.x {
//                    imArray[y].append(AnyView(ProgressView().progressViewStyle(.circular)))
//                }
//            }
//            let sortedY = tiles.sorted { lhs, rhs in
//                lhs.y < rhs.y
//            }
//            let sortedX = tiles.sorted { lhs, rhs in
//                lhs.x < rhs.x
//            }
//            let tlb = tileBbox((sortedX[0].x, sortedY[0].y), withZoom: z)
//            let brb = tileBbox((sortedX[sortedX.count-1].x, sortedY[sortedY.count-1].y), withZoom: z)
//            bbox = (tlb.tl, brb.br)
//            for tile in tiles {
//                Task.init {
//                    imArray[tile.y - sortedY[0].y][tile.x - sortedX[0].x] = AnyView(try await tile.getImage().resizable())
//                }
//            }
//        }
//    }
//}
//
//struct MapView_Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
