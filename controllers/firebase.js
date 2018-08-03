const admin = require('firebase-admin');
const serviceAccount = require('../utils/hanium-2018-firebase-adminsdk-lb97b-95e7402c08.json');
const firebase = require('../utils/firebase.json');
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
    databaseURL: firebase.databaseURL
});

const db = admin.database();

const DB_ASSETS = 'asset';

exports.getAssets = async (assets) => {
    const parallel = assets.map(async asset => {
        let ref = db.ref(`${DB_ASSETS}/${asset.id}`);
        const snapshot = await ref.once('value');
        asset.imageUrl = snapshot.val().imageUrl;
    });
    await Promise.all(parallel);
};