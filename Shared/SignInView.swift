//
//  SignInView.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/15/22.
//

import SwiftUI

struct SignInView: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var status: Color = .red
    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Circle()
                            .foregroundColor(status)
                            .frame(width: 10, height: 10)
                            .onAppear {
                                status = checkIfSignedIn() ? .green : .red
                            }
                    }
                }
                Section {
                    TextField("Username", text: $username)
                    SecureField("Password", text: $password)
                }
                Section {
                    Button {
                        if !checkIfSignedIn() {
                            Task.init {
                                let success = try await signIn(username: username, password: password)
                                status = success ? .green : .red
                            }
                            status = .yellow
                        }
                    } label: {
                        Text("Sign In")
                    }
                }
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
