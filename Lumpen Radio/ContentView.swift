//
//  ContentView.swift
//  Lumpen Radio
//
//  Created by Anthony on 10/20/19.
//  Copyright © 2019 Public Media Institute. All rights reserved.
//

import SwiftUI

// Constants
fileprivate let CUSTOM_FONT = "Akkurate-Regular"
fileprivate let RADIO_IMAGE_NAME = "RadioButton"
fileprivate let RADIO_BUTTON_MIN: CGFloat = 100
fileprivate let RADIO_BUTTON_MAX_IDEAL: CGFloat = 250
fileprivate let OPACITY_FACTOR = 0.77

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
    @ObservedObject var radio = Radio()
    
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
                RadioButton(radio: self.radio)
            }
            Text(radio.bottomText)
                .font(.custom(CUSTOM_FONT, size: 22))
                .foregroundColor(.white)
                .background(Color.blue)
                .opacity(OPACITY_FACTOR)
        }.padding()
    }
}

struct RadioButton: View {
    @ObservedObject var radio: Radio
    
    init(radio: Radio) {
        self.radio = radio
    }
    
    var body: some View {
        Button(action: {
            // Turn radio on/off
            self.radio.toggleRadio()
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
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
