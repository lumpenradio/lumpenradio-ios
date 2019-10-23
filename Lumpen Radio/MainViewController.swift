//
//  MainViewController.swift
//  Lumpen Radio
//
//  Created by Anthony on 10/22/19.
//  Copyright © 2019 Public Media Institute. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, RadioDelegate {

    private var radio: Radio?
    @IBOutlet weak var radioSubtext: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        radio = Radio(self)
    }
    
    @IBAction func radioButtonTapped(_ sender: Any) {
        radio?.toggleRadio()
    }
    
    func radioToggled(_ textContent: String) {
        radioSubtext.text = textContent
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
