use cs315
var a = db.A1.find()
var b = db.B1.find()
db.B.explain("executionStats").aggregate([ { $sort : {B3:1} } ])