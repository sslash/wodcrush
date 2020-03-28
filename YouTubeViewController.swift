//
//  YouTubeViewController.swift
//  wodcrush
//
//  Created by michael gunnulfsen on 14/01/2020.
//  Copyright © 2020 michael gunnulfsen. All rights reserved.
//

import UIKit
import WebKit

class YouTubeViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    var text: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let escapedQuery = self.text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let urlString = "https://www.youtube.com/results?search_query=" + escapedQuery!
        
        let url = URL(string: urlString)
        let request = URLRequest(url: url!)
        webView.load(request)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}
