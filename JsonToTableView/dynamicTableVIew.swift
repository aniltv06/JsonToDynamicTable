//
//  dynamicTableVIew.swift
//  JsonToTableView
//
//  Created by anilkumar thatha. venkatachalapathy on 29/09/16.
//  Copyright © 2016 Anil T V. All rights reserved.
//

import Foundation
import Cocoa

class dynamicTableVIew: NSWindowController, NSTableViewDelegate, NSTableViewDataSource {
    
    @IBOutlet weak var tableView: NSTableView?
    let defaultColumnWidth : Float = 100.0
    public var tableDataArray : NSMutableArray = []
    
    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.title = "URL Data"
        removeAllTableColumns()
        let tableDetails = tableDataArray[0] as! [String:Any]
        for (_, value) in tableDetails.enumerated() {
            let columnDetails = value
            let tableColumn = NSTableColumn(identifier: columnDetails.key)
            tableColumn.headerCell.title = columnDetails.key
            tableColumn.width = CGFloat(defaultColumnWidth)
            tableColumn.minWidth = 50.0
            tableColumn.maxWidth = 500.0
            let sortDescriptor = NSSortDescriptor(key: columnDetails.key, ascending: true)
            tableColumn.sortDescriptorPrototype = sortDescriptor
            self.tableView?.addTableColumn(tableColumn)
        }
        self.tableView?.columnAutoresizingStyle = .uniformColumnAutoresizingStyle
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
    }
    
    func removeAllTableColumns(){
        if self.tableView != nil {
            let columnCount = self.tableView!.tableColumns.count
            if columnCount > 0 {
                for _ in 0..<columnCount{
                    self.tableView?.removeTableColumn((self.tableView?.tableColumns[0])!)
                }
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableDataArray.count
    }
        
    public func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        let object = tableDataArray[row] as! [String : Any]
        if object[(tableColumn?.identifier)!] is NSNumber {
            let num : NSNumber = object[(tableColumn?.identifier)!] as! NSNumber
            return num.stringValue
        } else {
        return object[(tableColumn?.identifier)!]
        }
    }
    
    func tableView(_ tableView: NSTableView, sortDescriptorsDidChange oldDescriptors: [NSSortDescriptor]) {
        tableDataArray.sort(using: tableView.sortDescriptors)
        self.tableView?.reloadData()
    }
}
