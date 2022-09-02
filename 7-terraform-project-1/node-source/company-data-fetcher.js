exports.handler = async (event) => {
    console.log(JSON.stringify(event))
    const jsonBodyResponse = {"files-pending" :  "25"}
    const response = {
        statusCode: 200,
        body: JSON.stringify(jsonBodyResponse)
    };
    return response.body;
};
