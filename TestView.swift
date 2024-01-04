//
//  TestView.swift
//  Sonoros
//
//  Created by Jamie Ransom on 06/03/2021.

import Cocoa

import MetalKit

let metalRenderer = MetalRenderer(device: MTLCreateSystemDefaultDevice()!)

class TestView: MTKView {
    var level: CGFloat = 0 {
        didSet {
			
        }
    }
    
	required init(coder: NSCoder) {
		super.init(coder: coder)
		
		commonInit()
	}
	
    func commonInit() {
		device = MTLCreateSystemDefaultDevice()
		
		metalRenderer.addView(view: self)
    }
}
