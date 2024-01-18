//
//  CustomFloatingButton.swift
//  Logger Task
//
//  Created by Radwa Mohamed on 18/01/2024.
//

import Foundation
import UIKit

class CustomFloatingButton: UIButton{

    override init(frame: CGRect) {
          super.init(frame: frame)
          setUpFloatingButton()
      }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpFloatingButton()
    }
    
    private func setUpFloatingButton(){
        backgroundColor = .systemIndigo
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .medium))
        setImage(image, for: .normal)
        tintColor = .white
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 30
    }
}
