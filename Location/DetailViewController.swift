//
//  DetailViewController.swift
//  Location
//
//  Created by 전율 on 2024/01/18.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var url:URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            webView.load(URLRequest(url: url))
        }
    }
    
}
