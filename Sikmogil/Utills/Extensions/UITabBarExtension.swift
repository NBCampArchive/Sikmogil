//
//  UITabBarExtension.swift
//  Sikmogil
//
//  Created by 박현렬 on 6/23/24.
//

import UIKit

extension UITabBar {
    func changeTabBar(hidden: Bool, animated: Bool) {
        if self.isHidden == hidden { return }
        
        let frame = self.frame
        let offset = hidden ? frame.size.height : -frame.size.height
        let duration: TimeInterval = animated ? 0.5 : 0.0
        
        self.isHidden = false
        
        UIView.animate(withDuration: duration, animations: {
            self.frame = frame.offsetBy(dx: 0, dy: offset)
        }, completion: { _ in
            self.isHidden = hidden
        })
    }
}
