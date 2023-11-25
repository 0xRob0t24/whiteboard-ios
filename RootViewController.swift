import UIKit

class RootViewController: UIViewController {

    var drawingView: DrawingView!
    var lineWidthSlider: UISlider!

    override func loadView() {
        super.loadView()

        title = "Whiteboard"
        view.backgroundColor = .white

        drawingView = DrawingView(frame: view.bounds)
        drawingView.backgroundColor = .clear
        view.addSubview(drawingView)

        let clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(clearButtonTapped))
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveButtonTapped))

        lineWidthSlider = UISlider()
        lineWidthSlider.minimumValue = 1.0
        lineWidthSlider.maximumValue = 10.0
        lineWidthSlider.value = 5.0
        lineWidthSlider.addTarget(self, action: #selector(lineWidthChanged), for: .valueChanged)

        let stackView = UIStackView(arrangedSubviews: [lineWidthSlider])
        stackView.axis = .horizontal
        stackView.spacing = 16.0

        navigationItem.rightBarButtonItems = [saveButton, clearButton]
        navigationItem.titleView = stackView
    }

    @objc func clearButtonTapped() {
        drawingView.clear()
    }

    @objc func saveButtonTapped() {
        // Implement saving logic here
    }

    @objc func lineWidthChanged() {
        drawingView.lineWidth = CGFloat(lineWidthSlider.value)
    }
}

class DrawingView: UIView {

    private var path = UIBezierPath()
    private var lines: [Line] = []
    var lineWidth: CGFloat = 5.0

    override func draw(_ rect: CGRect) {
        for line in lines {
            line.path.stroke()
        }
        path.stroke()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = convert(touch.location(in: self), to: self.superview)
            path = UIBezierPath()
            path.lineWidth = lineWidth
            path.lineCapStyle = .round
            path.move(to: touchLocation)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = convert(touch.location(in: self), to: self.superview)
            path.addLine(to: touchLocation)
            setNeedsDisplay()
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = convert(touch.location(in: self), to: self.superview)
            let line = Line(path: path.copy() as! UIBezierPath, width: lineWidth, startPoint: path.currentPoint, endPoint: touchLocation)
            lines.append(line)
            path.removeAllPoints()  // Clear the path after each touch
            setNeedsDisplay()
        }
    }

    func clear() {
        lines = []
        setNeedsDisplay()
    }
}

struct Line {
    let path: UIBezierPath
    let width: CGFloat
    let startPoint: CGPoint
    let endPoint: CGPoint
}
