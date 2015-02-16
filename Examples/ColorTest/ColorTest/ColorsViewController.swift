import UIKit
import SackOfRainbows

class ColorsViewController: UITableViewController {

    var gen: ColorGenerator = theColor(red)

    var colors: [UIColor] = [];

    override func viewDidLoad() {

        // To make a single color, use `theColor()`. All your favorite `UIColor`s have been aliased for easy use.
        let redGenerator = theColor(red)

        // You can generate a bunch of colors in order using `theColors()` like so:
        let rainbow = theColors(red, orange, yellow, green, blue,
            UIColor(red: 0.29, green: 0.0, blue: 0.51, alpha: 1), purple)

        // Making a series of colors in a gradient is easy as well. Just indicate the start color, end color, and how many
        // steps start to finish.
        let tequilaSunrise = gradient().from(orange).to(red).steps(10)

        // To chain generators in sequence, use `then()`.
        let batman = theColors(blue, black)
        let robin = theColors(yellow, green, red)
        let batmanAndRobin = batman.then(robin)

        // To chain in parallel, use `alternate()`.
        let olympics = alternate(batman, robin)

        // Repeat a fixed number of times with `times()`.
        let doubleRainbow = rainbow.times(2)

        // To enter a world of endless color, use `forever()`.
        let blueToWhite = gradient().from(blue).to(white).steps(10)
        let whiteToBlue = gradient().from(white).to(blue).steps(10)
        let allTheWayAcrossTheSky = blueToWhite.then(whiteToBlue).forever()

        // Set `gen` to any of the generators above to try them out, or make your own.
        gen = redGenerator

        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Scroll View Method Overrides

    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let visiblePaths = tableView.indexPathsForVisibleRows as [NSIndexPath]?
        if let visibleRows = visiblePaths?.map({ x in x.row }) {
            if visibleRows.isEmpty || visibleRows.contains(reloadIndex()) {
                loadMoreColors()
            }
        }
    }

    func reloadIndex() -> Int {
        let totalRows = tableView.numberOfRowsInSection(0)
        return max(totalRows / 2, totalRows - 3)
    }

    func loadMoreColors() {
        if let color = gen.next() {
            colors.append(color)
            tableView.reloadData()
        }
    }

    // MARK: - Table View Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count > 0 ? colors.count : 1
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        if colors.count == 0 {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "messageCell")
            cell?.textLabel?.text = "Scroll to load colors."
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            return cell!
        }
        cell = tableView.dequeueReusableCellWithIdentifier("colorCell") as UITableViewCell?
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "colorCell")
            cell?.selectionStyle = UITableViewCellSelectionStyle.None
        }
        cell?.backgroundColor = colors[indexPath.row]
        return cell!
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
}
