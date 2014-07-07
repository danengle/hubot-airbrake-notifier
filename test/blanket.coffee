require("blanket") {
  "data-cover-never": "node_modules"
  pattern: ["airbrake-notification.coffee", "postman.coffee"]
  loader: "./node-loaders/coffee-script"
}
