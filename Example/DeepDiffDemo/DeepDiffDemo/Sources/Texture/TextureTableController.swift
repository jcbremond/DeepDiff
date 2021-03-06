//
//  TextureTableController.swift
//  DeepDiffDemo
//
//  Created by Gungor Basa on 26.02.2018.
//  Copyright © 2018 Hyper Interaktiv AS. All rights reserved.
//

import AsyncDisplayKit
import DeepDiff

class TextureTableController: ASViewController<ASDisplayNode> {

  var items: [Int] = []
  let rootNode = RootNode()

  init() {
    super.init(node: rootNode)
    node.backgroundColor = .white
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Reload", style: .plain, target: self, action: #selector(reload)
    )
    title = "ASTableNode"
    rootNode.tableNode.dataSource = self
    reload()
  }

  @objc func reload() {
    let oldItems = items
    items = DataSet.generateItems()
    let changes = diff(old: oldItems, new: items)

    let exception = tryBlock {
      self.rootNode.tableNode.reload(changes: changes, completion: { _ in

      })
    }

    if let exception = exception {
      print(exception as Any)
      print(oldItems)
      print(items)
      print(changes)
    }

  }
}

extension TextureTableController: ASTableDataSource {

  func numberOfSections(in tableNode: ASTableNode) -> Int {
    return 1
  }

  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return items.count
  }


  func tableNode(_ tableNode: ASTableNode, nodeBlockForRowAt indexPath: IndexPath) -> ASCellNodeBlock {
    return {
      let cell = TableCellNode()

      cell.text.attributedText = NSAttributedString(string: "\(self.items[indexPath.item])")

      return cell
    }
  }
}
