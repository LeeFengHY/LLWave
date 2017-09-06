//
//  ViewController.swift
//  LLWave
//
//  Created by moxian on 2017/9/5.
//  Copyright © 2017年 moxian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let wave  = WaveView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height / 2))
        wave.center = self.view.center
        wave.color1 = UIColor.magenta
        wave.color2 = UIColor.cyan
        self.view.addSubview(wave)
        wave.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

