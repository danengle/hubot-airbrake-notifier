require("blanket") {
  "data-cover-never": "node_modules"
  pattern: ["airbrake-notifier.coffee", "postman.coffee"]
  loader: "./node-loaders/coffee-script"
}
