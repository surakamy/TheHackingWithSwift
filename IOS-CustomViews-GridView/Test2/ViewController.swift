//
//  ViewController.swift
//  Test2
//
//  Created by Dmytro Kholodov on 5/11/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let themedColor = UIColor(patternImage: UIImage(named: "circuit")!)
    @IBOutlet var grid: GridView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var modes: UISegmentedControl!
    @IBAction func rebuild(_ slider: UISlider) {
        let val = Int(slider.value)

    /*** Example # 1 */
        grid.dimensions = (rows: val, cols: val, { x, y in
            let img = UIImageView(image: UIImage(named: "1847712"))
            img.contentMode = .scaleAspectFit
            return img
        })

        
    /*** Example # 2

        grid.dimensions = (val, val, { x, y in
            let filter = self.modes.selectedSegmentIndex
            switch filter {
            case 1:
                if (x == 1) || (y == 1) { return nil }
            case 2:
                if (x == 1) && (y == 1) { return nil }
            case 3:
                if (x == 1) != (y == 1) { return nil }
            case 4:
                if (x % 2 == 0) != (y % 2 == 0) { return nil }
            default:
                break
            }
            let view = UILabel()
            view.backgroundColor = self.themedColor
            view.layer.borderWidth = 0.5
            view.textAlignment = .center
            view.text = "[\(x):\(y)]"
            return view
        })
    */
    }
    @IBAction func changeMode(_ sender: UISegmentedControl) {
        rebuild(slider)
    }
}




final class GridView : UIView {
    typealias ColIndex = Int
    typealias RowIndex = Int
    typealias CustomizeCell = (RowIndex, ColIndex) -> UIView?
    typealias GridSetup = (cols: ColIndex, rows: RowIndex, handler: CustomizeCell?)


    /// - Parameter cols: Number of columns in the grid.
    /// - Parameter rows: Number of rows in the grid.
    /// - Parameter handler: Closure returns view for the cell.
    /// - Note: `dimensions` is set and released at `didSet`. Is it a hack or not?
    public var dimensions: GridSetup? { didSet { setupView(with: dimensions); dimensions = nil } }
    private var cells: [[UIView?]] = []

    override func layoutSubviews() {
        let (rows, cols) = cells.isEmpty ? (0, 0) : (cells.count, cells.first!.count)
        let newCellSize = CGSize(
            width:bounds.width/CGFloat(cols),
            height:bounds.height/CGFloat(rows))
        for r in 0..<rows {
            for c in 0..<cols {
                guard let view = cells[r][c] else { continue }
                let oldSize = view.bounds.size
                // Update to a new frame
                let newCellOrigin = CGPoint(
                    x: CGFloat(c) * newCellSize.width,
                    y: CGFloat(r) * newCellSize.height)
                view.frame = CGRect(
                    origin: newCellOrigin,
                    size: newCellSize)
                // When `bounds` was not changed due to its `intrinsicSize`
                if view.frame.size.equalTo(oldSize) {
                    // Center `view` in a cell `bounds` by changing its `center`
                    view.center = CGPoint(
                        x: newCellOrigin.x + newCellSize.width / CGFloat(2),
                        y: newCellOrigin.y + newCellSize.height / CGFloat(2))
                }
                // Call re-layout for `view` subviews.
                view.layoutSubviews()
            }
        }
    }

    private func setupView(with dimentions: GridSetup? = nil) {
        for view in subviews { view.removeFromSuperview() }
        guard let (rows, cols, handler) = dimensions else { return }
        cells = Array(repeating: Array(repeating: nil, count: cols), count: rows)
        for r in 0..<rows {
            for c in 0..<cols {
                guard let view = handler?(r, c) else { continue }
                addSubview(view)
                cells[r][c] = view
            }
        }
    }
}
