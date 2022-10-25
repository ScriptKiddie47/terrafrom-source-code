const aws = require("aws-sdk");
const dynamo = new aws.DynamoDB.DocumentClient({ region: "ap-south-1" });
exports.handler = async (event, context, callback) => {
    let responseList;
    await readMessage()
        .then((data) => {
            console.log(data);
            responseList = data.Items;
            data.Items.forEach((item) => {
                console.log(item.ST_CD);
            });
        })
        .catch((err) => {
            console.error(err);
        });
    const responseMsg = {
        statusCode : 200,
        body:JSON.stringify(responseList)
    };
    return responseMsg;
};

function readMessage() {
    const params = {
        TableName: "tectonic",
        IndexName: "E_DT_Index",
        KeyConditionExpression: "TRAN_TYP_CD = :trans AND E_DT > :eff_dt",
        ExpressionAttributeValues: {
            ':trans' : "NB",
            ':eff_dt' : "2020-10-10"
        }
    };
    return dynamo.query(params).promise();
}
