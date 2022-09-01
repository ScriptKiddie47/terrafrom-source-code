exports.handler = async (event) => {
    console.log(JSON.stringify(event))
    const message = `Hello ${event.key1}`
    return {
        "message " : message
     };;
};


// Input : {"key1":"Syndicate"}