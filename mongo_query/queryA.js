use cs315
var a = db.A1.find()
var b = db.B1.find()
db.A.explain("executionStats").find({ A1: {$lte : 50}})
// exp.executionStats.executionTimeMillis/1000