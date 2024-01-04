//
//  ViewController.swift
//
//  Created by Jamie on 30/10/2023.
//

import Cocoa

let NItems: Int = 100

class ViewController: NSViewController, NSCollectionViewDelegate, NSCollectionViewDataSource {
    
    @IBOutlet weak var grid: NSCollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        grid.delegate = self
        grid.dataSource = self
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return NItems
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        return 1
    }

    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        //Set up the mic grid item
        let item = grid.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "gridItem"), for: indexPath)
        //guard let gridtem = item as? gridItem else { return item }
        
        return item
        }
}

