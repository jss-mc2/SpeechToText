//
//  ViewController.swift
//  SpeechToText
//
//  Created by Jason Rich Darmawan Onggo Putra on 22/06/23.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.pushViewController(UIHostingController(rootView: PageView([
            InstructionView(Instruction.SAMPLE_DATA[0]),
            InstructionView(Instruction.SAMPLE_DATA[1]),
            InstructionView(Instruction.SAMPLE_DATA[2])
        ])), animated: true)
    }


}

