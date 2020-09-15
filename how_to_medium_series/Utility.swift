//
//  Utility.swift
//  how_to_medium_series
//
//  Created by Vijay on 15/09/20.
//  Copyright © 2020 Gokul. All rights reserved.
//

import UIKit

class Utility: NSObject {

}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

