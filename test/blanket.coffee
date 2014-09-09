require("blanket") {
  "data-cover-never": "node_modules"
  pattern: [
    "airbrake-notifier.coffee",
    "postman/base.coffee",
    "postman/common.coffee",
    "postman/slack.coffee",
    "postman.coffee"
  ]
  loader: "./node-loaders/coffee-script"
}
