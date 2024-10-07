//
//  EventsWebViewController.swift
//  Glenroe-Ballyorgan
//
//  Created by Liya Wang on 2024/9/12.
//
import WebKit
import UIKit


class EventsWebViewController: UIViewController {

    var webView: WKWebView!
    var url: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the web view
        webView = WKWebView(frame: self.view.bounds)
        view.addSubview(webView)

        // Load the URL if available
        if let eventURL = url {
            let request = URLRequest(url: eventURL)
            webView.load(request)
        } else {
            print("URL is nil")
        }
    }
}

