//
//  ContentView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/13/22.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        if checkIfSignedIn() {
            MainView()
        } else {
            SignInView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
