//
//  ContentView.swift
//  WatchyGPS WatchKit Extension
//
//  Created by Ben Goldberg on 7/13/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if checkIfSignedIn() {
            MainView()
                .edgesIgnoringSafeArea(.all)
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
