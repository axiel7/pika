//
//  AppDelegate.swift
//  Pika
//
//  Created by Charlie Gleason on 30/12/2020.
//

import Cocoa
import KeyboardShortcuts
import SwiftUI

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBarItem: NSStatusItem!
    var pikaWindow: NSWindow!
    var aboutWindow: NSWindow!
    var preferencesWindow: NSWindow!

    func applicationDidFinishLaunching(_: Notification) {
        // Create the status item
        statusBarItem = NSStatusBar.system.statusItem(withLength: CGFloat(NSStatusItem.variableLength))

        if let button = statusBarItem.button {
            button.image = NSImage(named: "StatusBarIcon")
            button.action = #selector(togglePopover(_:))
        }

        let contentView = ContentView()
            .frame(minWidth: 320,
                   idealWidth: 320,
                   maxWidth: 500,
                   minHeight: 150,
                   idealHeight: 150,
                   maxHeight: 350,
                   alignment: .center)

        pikaWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 0, height: 0),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .borderless],
            backing: .buffered, defer: false
        )
        pikaWindow.isReleasedWhenClosed = false
        pikaWindow.center()
        pikaWindow.title = "Pika"
        pikaWindow.level = .floating
        pikaWindow.isMovableByWindowBackground = true
        pikaWindow.standardWindowButton(NSWindow.ButtonType.zoomButton)!.isEnabled = false
        pikaWindow.toolbar = NSToolbar()

        let toolbarButtons = NSHostingView(rootView: ToolbarButtons())
        toolbarButtons.frame.size = toolbarButtons.fittingSize

        let titlebarAccessory = NSTitlebarAccessoryViewController()
        titlebarAccessory.view = toolbarButtons
        titlebarAccessory.layoutAttribute = .trailing

        pikaWindow.addTitlebarAccessoryViewController(titlebarAccessory)

        pikaWindow.setFrameAutosaveName("Pika Window")
        pikaWindow.contentView = NSHostingView(rootView: contentView)

        pikaWindow.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        KeyboardShortcuts.onKeyUp(for: .togglePika) { [self] in
            togglePopover(nil)
        }
    }

    @objc func togglePopover(_: AnyObject?) {
        if pikaWindow.isVisible {
            pikaWindow.orderOut(nil)
        } else {
            pikaWindow.makeKeyAndOrderFront(nil)
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    func createWindow(title: String) -> NSWindow {
        let window = NSWindow(
            contentRect: NSRect(x: 20, y: 20, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .fullSizeContentView],
            backing: .buffered,
            defer: false
        )
        window.level = .floating
        window.center()
        window.setFrameAutosaveName("\(title) Window")
        window.isReleasedWhenClosed = false
        return window
    }

    @objc func openAboutWindow() {
        if aboutWindow == nil { // create once
            aboutWindow = createWindow(title: "About")
            aboutWindow.contentView = NSHostingView(rootView: AboutView())
        }
        aboutWindow.makeKeyAndOrderFront(nil)
    }

    @objc func openPreferencesWindow() {
        if preferencesWindow == nil { // create once
            preferencesWindow = createWindow(title: "Preferences")
            preferencesWindow.contentView = NSHostingView(rootView: PreferencesView())
        }
        preferencesWindow.makeKeyAndOrderFront(nil)
    }

    @IBAction func handlePreferencesShortcut(_: Any) {
        openPreferencesWindow()
    }
}
