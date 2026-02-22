const { MongoClient } = require('mongodb');

async function test() {
    // Try with the mongodb native driver to get better error info
    const uri = 'mongodb+srv://amirfareed787898_db_user:As123456@snaplive.f8neltp.mongodb.net/?appName=snaplive';
    const client = new MongoClient(uri);
    try {
        await client.connect();
        await client.db("admin").command({ ping: 1 });
        console.log("SUCCESS: Pinged your deployment. You successfully connected to MongoDB!");
    } catch (err) {
        console.error("FAILED:", err.codeName || err.code, '-', err.message);
        // Check if it's an IP whitelist issue vs auth issue
        if (err.code === 8000) {
            console.log("This is an Atlas-level error (HandshakeError). Could be:");
            console.log("1. Wrong password");
            console.log("2. IP not whitelisted in Atlas Network Access");
        }
    } finally {
        await client.close();
    }
}
test();
