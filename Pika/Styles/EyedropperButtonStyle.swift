//
//  EyedropperButtonStyle.swift
//  Pika
//
//  Created by Charlie Gleason on 30/12/2020.
//

import SwiftUI

struct EyedropperButtonStyle: ButtonStyle {
    var color: Color
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? Color.blue : Color.white)
            .background(configuration.isPressed ? Color.white : color)
            .padding(0.0)
    }
}
