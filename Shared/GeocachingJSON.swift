//
//  GeocachingJSON.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/14/22.
//

import Foundation
import CoreLocation

struct Geocaches: Codable, Hashable, Identifiable {
    let id = UUID()
    var results: [Geocache]
}

struct Coordinates: Codable, Hashable {
    var latitude: Double
    var longitude: Double
}

struct Owner: Codable, Hashable {
    var code: String
    var username: String
}

struct Attribute: Codable, Hashable {
    var id: Int
    var name: String
    var isApplicable: Bool
}

struct Geocache: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var code: String
    var premiumOnly: Bool
    var favoritePoints: Int
    var geocacheType: Int
    var containerType: Int
    var difficulty: Double
    var terrain: Double
    var userFound: Bool?
    var userDidNotFind: Bool?
    var cacheStatus: Int
    var postedCoordinates: Coordinates? = Coordinates(latitude: 0, longitude: 0)
    var safePostedCoordinates: Coordinates {
        get {
            postedCoordinates ?? Coordinates(latitude: 0, longitude: 0)
        }
    }
    var userCorrectedCoordinates: Coordinates?
    var detailsUrl: String
    var hasGeotour: Bool
    var hasLogDraft: Bool? = false
    var placedDate: String
    var owner: Owner
    var lastFoundDate: String
    var trackableCount: Int
    var region: String
    var country: String
    var attributes: [Attribute]?
    var hasCallerNote: Bool? = false // false for non-premium members
    var distance: String
    var bearing: String
}

struct Creator: Codable, Hashable {
    var GroupTitle: String
    var GroupImageUrl: String
}

struct LogImage: Codable, Hashable {
    var ImageID: Int
    var ImageGuid: String
    var Name: String
    var Descr: String
    var FileName: String
    var Created: String
    var LogID: Int
    var CacheID: Int
    var ImageUrl: String?
}

struct Log: Codable, Hashable {
    var LogID: Int
    var CacheID: Int
    var LogGuid: String
    var Latitude: Double?
    var Longitude: Double?
    var LatLonString: String?
    var LogTypeID: Int
    var LogType: String
    var LogTypeImage: String
    var LogText: String
    var Created: String
    var Visited: String
    var UserName: String
    var MembershipLevel: Int
    var AccountID: Int
    var AccountGuid: String
    var Email: String
    var AvatarImage: String
    var GeocacheFindCount: Int
    var GeocacheHideCount: Int
    var ChallengesCompleted: Int
    var IsEncoded: Bool
    var creator: Creator
    var Images: [LogImage]
}

struct PageInfo: Codable, Hashable {
    var idx: Int
    var size: Int
    var totalRows: Int
    var totalPages: Int
    var rows: Int
}

struct Logs: Codable, Hashable, Identifiable {
    let id = UUID()
    var status: String
    var data: [Log]
    var pageInfo: PageInfo
}

enum status: Hashable {
    case succeeded
    case failed
    case notLoggedIn
}

func parse(json: Data) -> [Geocache] {
    let decoder = JSONDecoder()
    
    do {
        return try decoder.decode(Geocaches.self, from: json).results
    } catch let DecodingError.dataCorrupted(context) {
        print(context)
    } catch let DecodingError.keyNotFound(key, context) {
        print("Key '\(key)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch let DecodingError.valueNotFound(value, context) {
        print("Value '\(value)' not found:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch let DecodingError.typeMismatch(type, context)  {
        print("Type '\(type)' mismatch:", context.debugDescription)
        print("codingPath:", context.codingPath)
    } catch {
        print("error: ", error)
    }
    return []
}

// thanks c:geo
enum ContainerType: Int {
    case micro = 2
    case small = 8
    case regular = 3
    case large = 4
    case virtual = 5
    case other = 6
    case earthcache = 1
    func getString() -> String {
        switch self {
        case .micro:
            return "Micro"
        case .small:
            return "Small"
        case .regular:
            return "Regular"
        case .large:
            return "Large"
        case .virtual:
            return "Virtual"
        case .other:
            return "Other"
        case .earthcache:
            return "Other"
        }
    }
}

func getGeocachesFromJSON(centeredAt location: CLLocation, radius: Double, maxNumber: Int) async -> ([Geocache], Bool) {
    return await getGeocachesFromJSON(centeredAt: location.coordinate, radius: radius, maxNumber: maxNumber)
}

// false = rate limit
func getGeocachesFromJSON(centeredAt coordinate: CLLocationCoordinate2D, radius: Double, maxNumber: Int) async -> ([Geocache], Bool) {
    // radius = meters
    
    // https://www.hackingwithswift.com/read/7/3/parsing-json-using-the-codable-protocol
    let urlString = "https://www.geocaching.com/api/proxy/web/search/v2?skip=0&take=\(maxNumber)&asc=true&sort=distance&properties=callernote&rad=\(radius)&origin=\(coordinate.latitude)%2C\(coordinate.longitude)"

    print("Requesting \(urlString)")
    
    
    if let (_, data) = try? await getData(url: URL(string: urlString)!) {
        print(String(decoding: data, as: UTF8.self))
        if String(decoding: data, as: UTF8.self).contains("statusCode\":429") {
            return ([], false)
        }
        let caches = parse(json: data)
        print("Found \(caches.count) geocaches")
        return (caches, true)
    }
    return ([], true)
}

func getLogs(userToken: String, page: Int) async throws -> [Log] {
    if let (_, data) = try? await getData(url: URL(string: "https://www.geocaching.com/seek/geocache.logbook?tkn=\(userToken)&idx=\(page)&num=\(LOGS_PER_PAGE)&sortOrder=0")!) {
        print(String(decoding: data, as: UTF8.self))
        let decoder = JSONDecoder()
        
        if let logs = try? decoder.decode(Logs.self, from: data) {
            print("Found \(logs.data.count) logs")
            return logs.data
        }
        return []
    }
    return []
}

func decodeLogs(data: Data) -> Logs? {
    let decoder = JSONDecoder()
    
    do {
        let logs = try decoder.decode(Logs.self, from: data)
        return logs
    } catch {
        print("\(error)")
        return nil
    }
}
