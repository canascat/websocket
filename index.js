const express = require('express');
const http = require('http');
const WebSocket = require('ws');

const app = express();
const server = http.createServer(app);
const wss = new WebSocket.Server({ server });

let messages = []; // Stockage des messages

app.get('/', (req, res) => {
    res.sendFile(`${__dirname}/public/index.html`);
});

wss.on('connection', function connection(ws) {
    console.log('Un utilisateur s\'est connecté.');

    // Envoyer l'historique des messages au nouveau client
    messages.forEach((message) => {
        ws.send(message);
    });

    ws.on('message', function incoming(message) {
        if (message === "clearHistory") {
            // Effacer l'historique des messages
            messages = [];
            console.log('Historique des messages effacé.');
            // Aviser tous les clients de l'effacement de l'historique
            wss.clients.forEach(function each(client) {
                if (client.readyState === WebSocket.OPEN) {
                    client.send("clearHistory");
                }
            });
        } else {
            console.log('Message reçu: %s', message);
            messages.push(message);
            wss.clients.forEach(function each(client) {
                if (client.readyState === WebSocket.OPEN) {
                    client.send(message);
                }
            });
        }
    });

    ws.on('close', () => console.log('Un utilisateur s\'est déconnecté.'));
});

server.listen(3000, () => {
    console.log('Écoute sur le port 3000');
});
