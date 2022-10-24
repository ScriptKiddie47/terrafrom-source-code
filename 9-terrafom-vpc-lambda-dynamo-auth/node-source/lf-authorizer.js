exports.handler = async (event) => {
    let rest_api_id = process.env.rest_api_id
    console.log(event)
    let response = {};
    let auth = "Deny"
    if (event.authorizationToken === 'secret-key') {
        auth = "Allow"
    }
    response = {
        principalId: "user",
        policyDocument: {
            Version: "2012-10-17",
            Statement: [
                {
                    Action: "execute-api:Invoke",
                    Effect: auth,
                    Resource: `arn:aws:execute-api:ap-south-1:378475259575:${rest_api_id}/*/*`
                }
            ]
        }
    }

    return response;
};