//
//  ViewController.swift
//  Untangler
//
//  Created by Dmytro Kholodov on 5/19/19.
//  Copyright © 2019 HackingWithSwift. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var currentLevel = 0

    var scoreLabel = UILabel()

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var connections = [ConnectionView]()

    let renderedLines = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray

        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textColor = .white
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(scoreLabel)

        renderedLines.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(renderedLines)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: renderedLines.topAnchor),
            view.bottomAnchor.constraint(equalTo: renderedLines.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: renderedLines.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: renderedLines.trailingAnchor),
            scoreLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        levelUp()
    }

    func levelUp() {
        currentLevel += 1
        connections.forEach { $0.removeFromSuperview() }
        connections.removeAll()

        for _ in 1...(currentLevel+4) {
            let connection = ConnectionView(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
            connection.backgroundColor = .white
            connection.layer.cornerRadius = 22
            connection.layer.borderWidth = 2
            view.addSubview(connection)

            connections += [connection]

            connection.draggedChanged = { [weak self] in
                self?.redrawLines()
            }

            connection.draggedFinished = { [weak self] in
                self?.checkMove()
            }
        }

        for i in 0...connections.count - 1 {
            if i == connections.count - 1 {
                connections[i].after = connections[0]
            } else {
                connections[i].after = connections[i+1]
            }
        }

        repeat {
            connections.forEach { place($0) }
            self.redrawLines()
        } while levelClear()
    }

    func place(_ connection: ConnectionView) {
        let x = CGFloat.random(in: 20...view.bounds.maxX - 20)
        let y = CGFloat.random(in: 50...view.bounds.maxY - 50)
        connection.center = CGPoint(x: x, y: y)

    }

    func redrawLines() {
        let render = UIGraphicsImageRenderer(bounds: view.bounds)
        renderedLines.image = render.image { ctx in

            for c in connections {
                var isLinesCrossed = false
                for o in connections {
                    if linesCross(start1: c.center, end1: c.after.center, start2: o.center, end2: o.after.center) != nil {
                        isLinesCrossed = true
                        break
                    }
                }
                if isLinesCrossed {
                    UIColor.red.set()
                } else {
                    UIColor.green.set()
                }


                ctx.cgContext.strokeLineSegments(between: [c.after.center, c.center ])

            }
        }
    }


    func linesCross(start1: CGPoint, end1: CGPoint, start2: CGPoint, end2: CGPoint) -> (x: CGFloat, y: CGFloat)? {
        // calculate the differences between the start and end X/Y positions for each of our points
        let delta1x = end1.x - start1.x
        let delta1y = end1.y - start1.y
        let delta2x = end2.x - start2.x
        let delta2y = end2.y - start2.y

        // create a 2D matrix from our vectors and calculate the determinant
        let determinant = delta1x * delta2y - delta2x * delta1y

        if abs(determinant) < 0.0001 {
            // if the determinant is effectively zero then the lines are parallel/colinear
            return nil
        }

        // if the coefficients both lie between 0 and 1 then we have an intersection
        let ab = ((start1.y - start2.y) * delta2x - (start1.x - start2.x) * delta2y) / determinant

        if ab > 0 && ab < 1 {
            let cd = ((start1.y - start2.y) * delta1x - (start1.x - start2.x) * delta1y) / determinant

            if cd > 0 && cd < 1 {
                // lines cross – figure out exactly where and return it
                let intersectX = start1.x + ab * delta1x
                let intersectY = start1.y + ab * delta1y
                return (intersectX, intersectY)
            }
        }

        // lines don't cross
        return nil
    }

    func levelClear() -> Bool {

        for c in connections {

            for o in connections {
                if linesCross(start1: c.center, end1: c.after.center, start2: o.center, end2: o.after.center) != nil {
                    return false
                }
            }
        }
        return true
    }

    func checkMove() {
        if levelClear() {
            score += currentLevel*2
            view.isUserInteractionEnabled = false
            UIView.animate(withDuration: 0.5, delay: 1, options: [], animations:  {
                self.renderedLines.alpha = 0
                for c in self.connections {
                    c.alpha = 0
                }
            }
            ) { _ in
                self.view.isUserInteractionEnabled = true
                self.renderedLines.alpha = 1
                self.levelUp()
            }
        } else {
            score -= 1
        }
    }

}

