//
//  ContentView.swift
//  Lumpen Radio
//
//  Created by Anthony on 10/20/19.
//  Copyright © 2019 Public Media Institute. All rights reserved.
//

import SwiftUI

let CUSTOM_FONT = "Akkurate-Regular"
let RADIO_IMAGE_NAME = "RadioButton"
let RADIO_BUTTON_MIN: CGFloat = 100
let RADIO_BUTTON_MAX_IDEAL: CGFloat = 250
let OPACITY_FACTOR = 0.77

struct ContentView: View {
    var body: some View {
        ZStack {
            Image("Background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .aspectRatio(contentMode: .fill)
            MainContent()
        }
    }
}

struct MainContent: View {
    var body: some View {
        VStack(alignment: .center, spacing: 16.0) {
            Text("LUMPEN RADIO")
                .font(.custom(CUSTOM_FONT, size: 45))
                .fontWeight(.heavy)
                .foregroundColor(.white)
            Text("WLPN 105.5 FM Chicago")
                .font(.custom(CUSTOM_FONT, size: 26))
                .foregroundColor(.white)
            HStack {
                RadioButton()
            }
            Text("Tap above to tune in.")
                .font(.custom(CUSTOM_FONT, size: 22))
                .foregroundColor(.white)
                .background(Color.blue)
                .opacity(OPACITY_FACTOR)
        }.padding()
    }
}

struct RadioButton: View {
    @State private var showingRadioAlert = false
    
    var body: some View {
        Button(action: {
            self.showingRadioAlert = true
        }) {
            Image(RADIO_IMAGE_NAME)
            .resizable()
            .frame(minWidth: RADIO_BUTTON_MIN,
                   idealWidth: RADIO_BUTTON_MAX_IDEAL,
                   maxWidth: RADIO_BUTTON_MAX_IDEAL,
                   minHeight: RADIO_BUTTON_MIN,
                   idealHeight: RADIO_BUTTON_MAX_IDEAL,
                   maxHeight: RADIO_BUTTON_MAX_IDEAL,
               alignment: .center)
        }
        .background(Color.white)
        .opacity(OPACITY_FACTOR)
        .alert(isPresented: $showingRadioAlert) {
            Alert(title: Text("Nice"), message: Text("You clicked on the radio!"), dismissButton: .default(Text("Dismiss")))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
