//
//  ViewController.swift
//  PALOpensource
//
//  Created by pikachu987 on 01/12/2021.
//  Copyright (c) 2021 pikachu987. All rights reserved.
//

import UIKit
import PALOpensource

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Present", style: .plain, target: self, action: #selector(self.presentTap(_:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Push", style: .plain, target: self, action: #selector(self.pushTap(_:)))
    }
    
    @objc private func presentTap(_ sender: UIBarButtonItem) {
        let viewController = OpensourceLicenseViewController(plistPath: Bundle.main.path(forResource: "OpensourceLicense", ofType: "plist"))
        viewController.delegate = self
        self.present(UINavigationController(rootViewController: viewController), animated: true, completion: nil)
    }
    
    @objc private func pushTap(_ sender: UIBarButtonItem) {
        let viewController = OpensourceLicenseViewController(plistPath: Bundle.main.path(forResource: "OpensourceLicense", ofType: "plist"))
        viewController.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: viewController, action: #selector(viewController.backTap(_:)))
        self.navigationController?.pushViewController(viewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: ViewController: OpensourceLicenseDelegate
extension ViewController: OpensourceLicenseDelegate {
    
}
