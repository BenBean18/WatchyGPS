//
//  LogView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/21/22.
//

import SwiftUI

struct LogView: View {
    var log: Log = Log(LogID: 1035437962, CacheID: 4205279, LogGuid: "f1dd978c-9923-43b3-b913-bbd4186e7e5f", Latitude: nil, Longitude: nil, LatLonString: Optional(""), LogTypeID: 2, LogType: "Found it", LogTypeImage: "2.png", LogText: "<p>In the area to visit my daughter who has recently relocated to Durham. Had a nice walk around the garden, and found this one with ease. I wasn’t planning to look, so had no writing implement. Took a photo of the last log. TFTC!￼</p>\n", Created: "07/22/2021", Visited: "07/22/2021", UserName: "OzGuff", MembershipLevel: 3, AccountID: 155595, AccountGuid: "ec4dcdb3-0d7d-40c8-bb99-3ef14b211221", Email: "", AvatarImage: "8a3bfc0b-5578-4f6b-87a0-6467a12b2fd5.jpg", GeocacheFindCount: 6142, GeocacheHideCount: 2203, ChallengesCompleted: 0, IsEncoded: false, creator: Creator(GroupTitle: "Premium Member", GroupImageUrl: "/images/icons/prem_user.gif"), Images: [LogImage(ImageID: 64080649, ImageGuid: "c602d90a-de96-421a-b17b-eb7da8f24f23", Name: "", Descr: "", FileName: "c602d90a-de96-421a-b17b-eb7da8f24f23.jpg", Created: "07/22/2021", LogID: 1035437962, CacheID: 4205279, ImageUrl: nil), LogImage(ImageID: 64080650, ImageGuid: "97d99585-0ef0-45ff-ad52-7d4f7a9f7503", Name: "", Descr: "", FileName: "97d99585-0ef0-45ff-ad52-7d4f7a9f7503.jpg", Created: "07/22/2021", LogID: 1035437962, CacheID: 4205279, ImageUrl: nil), LogImage(ImageID: 64080651, ImageGuid: "b25e3280-3cd7-4e9f-87de-f3e8170267b7", Name: "", Descr: "", FileName: "b25e3280-3cd7-4e9f-87de-f3e8170267b7.jpg", Created: "07/22/2021", LogID: 1035437962, CacheID: 4205279, ImageUrl: nil)])
    func loadImage(url: URL) async throws -> Image {
        let (_, data) = try await getData(url: url)
        return Image(uiImage: UIImage(data: data) ?? UIImage(systemName: "exclamationmark.triangle")!)
    }
    @State var imgs: [ImageViewData] = []
    struct ImageViewData {
        var logIm: LogImage
        var im: Image? = nil
    }
    @State var imgPresented: Bool = false
    @State var imgIdx: Int = 0
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "person.circle.fill")
                Text(log.UserName)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Spacer()
                Text(log.Visited)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                Spacer()
                #if !os(watchOS)
                Text(log.LogType)
                #endif
                if log.LogType == "Found it" {
                    Smiley()
                        .frame(width: 16, height: 16)
                }
                if log.LogType == "Didn't find it" {
                    SadFace()
                        .frame(width: 16, height: 16)
                }
            }
            .font(.system(.body, design: .rounded))
            Text(log.LogText)
            HStack {
                ForEach(0..<log.Images.count) { idx in
                    Button {
                        Task.init {
                            if imgs[idx].im == nil {
                                imgs[idx].im = try await loadImage(url: URL(string: "https://img.geocaching.com/cache/log/large/\(imgs[idx].logIm.FileName)")!)
                            }
                        }
                        imgIdx = idx
                        imgPresented = true
                    } label: {
                        Image(systemName: "photo")
                            .font(.body)
                    }
                }
            }
        }
        .padding()
        .sheet(isPresented: $imgPresented) {
            if imgs.count > 0 && imgs[imgIdx].im != nil {
                imgs[imgIdx].im!.resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .onAppear {
            for im in log.Images {
                imgs.append(ImageViewData(logIm: im))
            }
        }
    }
}

struct LogView_Previews: PreviewProvider {
    static var previews: some View {
        LogView()
    }
}
