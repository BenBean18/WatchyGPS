//
//  PreviewView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/19/22.
//

import SwiftUI

struct PreviewViewWatch: View {
    var body: some View {
        Group {
            LogView()
        }
    }
}

struct PreviewViewWatch_Previews: PreviewProvider {
    static var previews: some View {
        PreviewViewWatch()
    }
}
