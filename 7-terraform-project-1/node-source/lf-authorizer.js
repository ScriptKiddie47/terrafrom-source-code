exports.handler = async(event) => {
    console.log(event)
    let response = {
        "isAuthorized": false,
        "context": {
            "stringKey": "defaultDeny",
        }
    };   
    if (event.headers.authorization === "secretToken") {
        response = {
            "isAuthorized": true,
            "context": {
                "stringKey": "Customer1",
            }
        };
    }
    return response;
};