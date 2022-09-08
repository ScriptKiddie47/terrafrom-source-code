const fs = require("fs");
var csvfile = fs.readFileSync("sample_data.csv");
function csvJSON(csv) {
    const result = []
    const lines = csv.split(/\r\n|\n/);
    for (var i = 1; i < lines.length; i++) {
        let currentLine = lines[i].split(",");
        let obj = {}
        for (var j = 1; j < 4; j++) {
            obj = {}
            obj.Month = currentLine[0].trim().replace(/["]+/g, '');
            obj.P1Sale = currentLine[1].trim();;
            obj.P2Sale = currentLine[2].trim();
            obj.P3Sale = currentLine[3].trim();
        }
        result.push(obj)
    }
    return result;
}
let resultObj = csvJSON(csvfile.toString());

exports.handler = async (event) => {
    console.log(JSON.stringify(event))
    let responseList = []
    resultObj.forEach(e => {
        if (e.P3Sale === event.queryStringParameters.P3Sale) {
            responseList.push({ month: e.Month });
        }
    })
    const response = {
        statusCode: 200,
        body: JSON.stringify(responseList)
    };
    return response;
};
