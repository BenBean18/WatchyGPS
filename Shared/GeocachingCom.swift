//
//  GeocachingCom.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/14/22.
//

import Foundation
import CoreLocation

// HUGE shoutout to c:geo and https://github.com/cgeo/cgeo/blob/master/main/src/cgeo/geocaching/connector/gc/GCLogin.java for showing me the authentication protocol, I was getting a bit stuck
// Important note: there are two __RequestVerificationTokens. One is in the form and one is a cookie. Pretend you're a browser.

// https://stackoverflow.com/a/53652037
extension String {
    func groups(for regexPattern: String) -> [[String]] {
        do {
            let text = self
            let regex = try NSRegularExpression(pattern: regexPattern)
            let matches = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return matches.map { match in
                return (0..<match.numberOfRanges).map {
                    let rangeBounds = match.range(at: $0)
                    guard let range = Range(rangeBounds, in: text) else {
                        return ""
                    }
                    return String(text[range])
                }
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
    
    mutating func replace(regex: String, with: String) {
        self = self.replacingOccurrences(of: regex, with: with, options: .regularExpression, range: nil)
    }
}

func checkIfSignedIn() -> Bool {
    for cookie in HTTPCookieStorage.shared.cookies ?? [] {
        if cookie.name == "gspkauth" && cookie.expiresDate ?? Date.distantPast > Date.init() {
            return true
        }
    }
    return false
}

// returns success/failure
func signIn(username: String, password: String) async throws -> Bool {
    let signedintokencookie = try await requestVerificationToken()
    let signedin = signedintokencookie.0
    let token = signedintokencookie.1
    let cookies_req = signedintokencookie.2
    if signedin {
        print("Already signed in! Exiting")
        return true
    }
    let body = "__RequestVerificationToken=\(token)&ReturnUrl=%2Fplay&UsernameOrEmail=\(username)&Password=\(password)"
    var headers = HTTPCookie.requestHeaderFields(with: cookies_req)
    headers["User-Agent"] = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36"
    print("Signing in...")
    let respdata = try await postData(url: URL(string: "https://www.geocaching.com/account/signin")!, body: body.data(using: .utf8), headerFields: headers)
    let resp = respdata.0
    print("Sent signin request")
    let cookies = HTTPCookie.cookies(withResponseHeaderFields: resp!.allHeaderFields as! [String : String], for: URL(string: "https://www.geocaching.com/account/signin")!) // yum!
    HTTPCookieStorage.shared.setCookies(cookies, for: URL(string: "https://www.geocaching.com/account/signin")!, mainDocumentURL: nil)
    for cookie in cookies {
        if cookie.name == "gspkauth" {
            print("Signed in!")
        }
    }
    return checkIfSignedIn()
}

func requestVerificationToken() async throws -> (Bool, String, [HTTPCookie]) {
    print("Requesting verification token...")
    let respdata: (HTTPURLResponse?, Data) = try await getData(url: URL(string: "https://www.geocaching.com/account/signin?returnUrl=%2fplay")!)
    let resp = respdata.0
    let data = respdata.1
    if resp == nil {
        return (false, "", [])
    }
    let cookies = HTTPCookie.cookies(withResponseHeaderFields: resp!.allHeaderFields as! [String : String], for: URL(string: "https://www.geocaching.com/account/signin")!) // yum!
    let data_str = String(decoding: data, as: UTF8.self)
    if data_str.contains("var dataLayer = [{") {
        print("Already signed in!")
        return (true, "", [])
    }
    let form_token = data_str.groups(for: "<input[^n]+name=\"__RequestVerificationToken\"[^v]+value=\"([^\"]+)\"")[0][1]
    return (false, form_token, cookies)
}

func getData(url: URL) async throws -> (HTTPURLResponse?, Data) {
    var config: URLSessionConfiguration = .default
    config.requestCachePolicy = .returnCacheDataElseLoad
    //config.timeoutIntervalForResource = 10.0
    let session = URLSession(configuration: config)
    var request: URLRequest = URLRequest(url: url)
    request.allHTTPHeaderFields = HTTPCookie.requestHeaderFields(with: HTTPCookieStorage.shared.cookies ?? [])
    request.cachePolicy = .returnCacheDataElseLoad
    request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
    //request.timeoutInterval = 10.0
    
    let downloadTask = Task(priority: .high) { () -> (Data, URLResponse) in
        return try await session.data(from: url)
    }
    let (data, response) = try await downloadTask.value
    
    return (response as? HTTPURLResponse, data)
}

// https://thisdevbrain.com/how-to-use-async-await-with-ios-13/
extension URLSession {
    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: url) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
    
    @available(iOS, deprecated: 15.0, message: "This extension is no longer necessary. Use API built into SDK")
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation { continuation in
            let task = self.dataTask(with: request) { data, response, error in
                guard let data = data, let response = response else {
                    let error = error ?? URLError(.badServerResponse)
                    return continuation.resume(throwing: error)
                }
                
                continuation.resume(returning: (data, response))
            }
            
            task.resume()
        }
    }
}

class NoRedirectDelegate: NSObject, URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, willPerformHTTPRedirection response: HTTPURLResponse, newRequest request: URLRequest, completionHandler: @escaping (URLRequest?) -> Void) {
        completionHandler(nil)
    }
}

func postData(url: URL, body: Data?, headerFields: [String : String]) async throws -> (HTTPURLResponse?, Data) {
    var request: URLRequest = URLRequest(url: url)
    request.allHTTPHeaderFields = headerFields
    request.httpMethod = "POST"
    request.httpBody = body
    request.httpShouldHandleCookies = true
    
    let session = URLSession(configuration: .default, delegate: NoRedirectDelegate(), delegateQueue: nil)
    let (data, response) = try await session.data(for: request)
    
    return (response as? HTTPURLResponse, data)
}

//struct Geocache: Codable, Hashable, Identifiable {
//    var id: Int
//    var name: String
//    var code: String
//    var premiumOnly: Bool
//    var favoritePoints: Int
//    var geocacheType: Int
//    var containerType: Int
//    var difficulty: Double
//    var terrain: Double
//    var userFound: Bool
//    var userDidNotFind: Bool
//    var cacheStatus: Int
//    var postedCoordinates: Coordinates
//    var detailsUrl: String
//    var hasGeotour: Bool
//    var hasLogDraft: Bool
//    var placedDate: String
//    var owner: Owner
//    var lastFoundDate: String
//    var trackableCount: Int
//    var region: String
//    var country: String
//    var attributes: [Attribute]?
//    var hasCallerNote: Bool
//    var distance: String
//    var bearing: String
//}

struct Trackable {
    var name: String
    var iconURL: URL? = nil
    var lastLogDate: Date
    var owner: Owner
    var location: URL? = nil
    var distance: Double // in kilometers
    var detailsURL: URL? = nil
    init() {
        name = ""
        lastLogDate = Date()
        owner = Owner(code: "", username: "")
        distance = 0
    }
}

struct GeocacheDetails {
    var id = UUID()
    var description: String
    var hint: String
    var waypoints: [Waypoint]
    var getLogs: (Int) async throws -> [Log]
    var getTBs: () async throws -> [Trackable]
    init() {
        self.description = ""
        self.hint = ""
        self.waypoints = []
        self.getLogs = { _ in return [] }
        self.getTBs = { return [] }
    }
}

struct Waypoint: Codable, Hashable, Identifiable {
    var id = UUID()
    var name: String
    var strCoordinates: String
    var coordinates: CLLocationCoordinate2D {
        get {
            let matches = strCoordinates.groups(for: "([NS]) (\\d+)[^\\d]+(\\d+)\\.(\\d+) ([EW]) (\\d+)[^\\d]+(\\d+)\\.(\\d+)")
            let lat = (Double(matches[0][2])! + (Double(matches[0][3])!+Double(matches[0][4])!/1000)/60.0) * (matches[0][1] == "N" ? 1 : -1)
            let lon = (Double(matches[0][6])! + (Double(matches[0][7])!+Double(matches[0][8])!/1000)/60.0) * (matches[0][5] == "E" ? 1 : -1)
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
    }
    init() {
        self.name = ""
        self.strCoordinates = ""
    }
}

// https://www.hackingwithswift.com/example-code/strings/how-to-calculate-the-rot13-of-a-string
extension String {
    func rot13() -> String {
        return ROT13.string(self)
    }
}

struct ROT13 {
    // create a dictionary that will store our character mapping
    private static var key = [Character: Character]()
    
    // create arrays of all uppercase and lowercase letters
    private static let uppercase = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private static let lowercase = Array("abcdefghijklmnopqrstuvwxyz")
    private static var bracketed = false
    
    static func string(_ string: String) -> String {
        // if this is the first time the method is being called, calculate the ROT13 key dictionary
        if ROT13.key.isEmpty {
            for i in 0 ..< 26 {
                ROT13.key[ROT13.uppercase[i]] = ROT13.uppercase[(i + 13) % 26]
                ROT13.key[ROT13.lowercase[i]] = ROT13.lowercase[(i + 13) % 26]
            }
        }
        
        // now return the transformed string
        let transformed = string.map ({
            if $0 == "[" { bracketed = true }
            if !bracketed { return ROT13.key[$0] ?? $0 }
            if $0 == "]" { bracketed = false }
            return $0
        } as (Character) -> Character)
        return String(transformed)
    }
}

// copying parsing patterns from c:geo
let PATTERN_HINT = "(?s)<div id=\"div_hint\"[^>]*>(.*?)</div>";
let PATTERN_DESC = "(?s)<span id=\"ctl00_ContentBody_LongDescription\">(.*?)</span>\\s*</div>\\s*<(p|div) id=\"ctl00_ContentBody"
let PATTERN_WPTYPE = "\\/WptTypes\\/sm\\/(.+)\\.jpg";
let PATTERN_WPLATLON = "<td>\n([^&]+)&nbsp;\n +\n"
let PATTERN_WPNAME = "<td>\n +<a[^>]+>([^<]+)</a>"
let PATTERN_WPNOTE = "(?s)colspan=\"6\">(.*)</td>"
let PATTERN_USERTOKEN = "userToken = '(.+)'"
let LOGS_PER_PAGE = 25

func getDetails(url: URL = URL(string: "http://localhost/TestGeocacheDetails.html")!) async throws -> GeocacheDetails {
    let (_, data) = try await getData(url: url)
    let dataStr = String(decoding: data, as: UTF8.self)
    var details = GeocacheDetails()
    details.hint = dataStr.groups(for: PATTERN_HINT)[0][1].replacingOccurrences(of: "<br[^>]*>", with: "\n", options: .regularExpression, range: nil).trimmingCharacters(in: .whitespacesAndNewlines).rot13()
    details.description = dataStr.groups(for: PATTERN_DESC)[0][1]
    let token = dataStr.groups(for: PATTERN_USERTOKEN)[0][1]
    details.getLogs = { page in try await getLogs(userToken: token, page: page) }
    if dataStr.groups(for: PATTERN_WPTYPE).count > 0 {
        print("Waypoint exists!")
        let wpnames = dataStr.groups(for: PATTERN_WPNAME)
        let wpcoords = dataStr.groups(for: PATTERN_WPLATLON)
        for i in 0..<wpnames.count {
            var wp = Waypoint()
            wp.name = wpnames[i][1]
            wp.strCoordinates = wpcoords[i][1].trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    return details
}

let PATTERN_TBNAME = "track/details\\.aspx[^>]+>([^<]+)</a>"
let PATTERN_TBROW = "(?s)<tr[^>]*>\n                <td>(.+?)<\\/tr>"
let PATTERN_TBICON = "<img src='(https:\\/\\/www\\.geocaching.com\\/images\\/WptTypes\\/[^']+)"
let PATTERN_TBDATE = "([\\d]+)\\/([\\d]+)\\/([\\d]+)"
let PATTERN_TBOWNER = "\\/p\\/\\?guid=([^\"]+)\">([^<]+)"
let PATTERN_TBDISTKM = "(\\d+) km"
let PATTERN_TBDISTMI = "(\\d+) mi"
let PATTERN_TBDETAILS = "<a href=\"(https:\\/\\/www\\.geocaching\\.com\\/track\\/details\\.aspx\\?[^\"]+)"

// format: https://www.geocaching.com/track/search.aspx?code=GCCODE
func getTBs(url: URL = URL(string: "https://www.geocaching.com/track/search.aspx?code=GC40")!) async throws -> [Trackable] {
    //let (_, data) = try await postDatta((ur))
    return []
}

func getTBsOnPage(html: String) -> [Trackable] {
    let groups = html.groups(for: "(?s)<tr[^>]*>\n                <td>(.+?)<\\/tr>")
    var trackables: [Trackable] = []
    for group in groups {
        var trackable = Trackable()

        trackable.name = group[1].groups(for: PATTERN_TBNAME)[0][1]

        trackable.iconURL = URL(string: group[1].groups(for: PATTERN_TBICON)[0][1])!

        let dateGroups = group[1].groups(for: PATTERN_TBDATE)[0]
        var dateComponents = DateComponents()
        dateComponents.year = Int(dateGroups[3])
        dateComponents.month = Int(dateGroups[1])
        dateComponents.day = Int(dateGroups[2])
        let userCalendar = Calendar(identifier: .gregorian)
        trackable.lastLogDate = userCalendar.date(from: dateComponents)!

        let ownerGroups = group[1].groups(for: PATTERN_TBOWNER)[0]
        trackable.owner.code = ownerGroups[1]
        trackable.owner.username = ownerGroups[2]

        // no location for right now. if you need it do something like this (?s)\/td.+?\/td.+?\/td.+?\/td>.+?<a

        let kmGroups = group[1].groups(for: PATTERN_TBDISTKM)
        let miGroups = group[1].groups(for: PATTERN_TBDISTMI)
        if kmGroups.count > 0 {
            trackable.distance = Double(kmGroups[0][1])!
        } else if miGroups.count > 0 {
            trackable.distance = Double(miGroups[0][1])! * 1.609344
        } else {
            trackable.distance = Double.nan // wat
        }

        trackable.detailsURL = URL(string: group[1].groups(for: PATTERN_TBDETAILS)[0][1])!

        trackables.append(trackable)
    }
    return trackables
}
