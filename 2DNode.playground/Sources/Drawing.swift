import aStar
import SpriteKit
import PlaygroundSupport

public var rootNode = SKNode()

open class RedDot: SKNode {
    let shape = SKShapeNode(circleOfRadius: 3)
    let label = SKLabelNode()
    
    public init(x: CGFloat, y: CGFloat, label labelText: String) {
        super.init()
        
        shape.fillColor = .red
        addChild(shape)
        
        label.text = labelText
        label.fontSize = 12
        label.position.y = 3
        label.fontColor = .red
        addChild(label)
        
        (position.x, position.y) = (x, y)
        rootNode.addChild(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var strokeColor: NSColor {
        get {
            return shape.strokeColor
        }
        set {
            shape.strokeColor = newValue
        }
    }
}

public var connections = Dictionary<SKNode, [SKNode: DirectedLine]>()

public class DirectedLine: SKNode {
    let line: SKShapeNode
    let source, target: SKNode
    public init(from source: SKNode, to target: SKNode) {
        (self.source, self.target) = (source, target)
        let linePath = CGMutablePath()
        linePath.move(to: CGPoint(x: 0, y: 0))
        linePath.addLine(to: CGPoint(x: 1, y: 0))
        line = SKShapeNode(path: linePath)
        line.strokeColor = .darkGray
        
        super.init()

        updateLength()
        insertChild(line, at: 0)
        
        constraints = [
            SKConstraint.distance(SKRange(constantValue: 0), to: source),
            SKConstraint.orient(to: target, offset: SKRange(constantValue: 0))
        ]
        
        rootNode.addChild(self)
        if connections[source] == nil {
            connections[source] = [target: self]
        } else {
            connections[source]![target] = self
        }
    }
    
    public func updateLength() {
        let difference = target.position - source.position
        line.xScale = hypot(difference.dx, difference.dy)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var strokeColor: NSColor {
        get { return line.strokeColor }
        set { line.strokeColor = newValue }
    }
}
