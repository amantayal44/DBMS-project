use cs315
var a = db.A1.find()
var b = db.B1.find()
db.B.explain("executionStats").aggregate( [ { $lookup: { from: "A", localField: "B2", foreignField: "A1", as: "_A" }} ,{ $project: { B1:1, B2:1,B3:1,"_A.A2":1 }} ] ,{"allowDiskUse":true})