//
//  AboutViewController.swift
//  BullsEye
//
//  Created by Mohsin Ali Ayub on 20.01.25.
//

import UIKit
import WebKit

class AboutViewController: UIViewController {
    
    /// The web view to display game information.
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load and display game info from .html file.
        loadHTMLPage()
    }
    
    @IBAction func close() {
        dismiss(animated: true)
    }
    
    /// Loads the HTML content from a bundled .html file in `webView`.
    func loadHTMLPage() {
        // Find the URL for the bundled .html file.
        if let url = Bundle.main.url(forResource: "BullsEye", withExtension: "html") {
            // Create a request and load it in our webView object.
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
