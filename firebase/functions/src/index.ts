import * as functions from 'firebase-functions';

import * as admin from 'firebase-admin';
admin.initializeApp(functions.config().firebase);

import * as twilio from 'twilio';

const TWILIO_SID = '';
const TWILIO_AUTH_TOKEN = '';
const TWILIO_NUMBER = '';

export const onRegistration = functions.database.ref('/verifications/{phoneNumber}').onWrite(event => {
    if (event.data.val() !== 'new') return null;

    const phoneNumber = event.params.phoneNumber;

    // TODO(devin): Math.random is insecure #slohacks
    const code = (Math.floor(Math.random() * 9000) + 1000).toString();

    event.data.ref.set(code).catch();

    const twilioClient = new twilio(TWILIO_SID, TWILIO_AUTH_TOKEN);

    return twilioClient.messages.create({
        body: 'Your Cartpool verification code is: ' + code,
        from: TWILIO_NUMBER,
        to: phoneNumber,
    }).then((response) => {
        console.log(response);
    });
});

export const onInvitation = functions.database.ref('/invites/{phoneNumber}').onWrite(event => {
    const phoneNumber = event.params.phoneNumber;

    const fromUserNumber = event.data.val()['fromUserPhone'];
    const fromUserName = event.data.val()['fromUserName'];

    const twilioClient = new twilio(TWILIO_SID, TWILIO_AUTH_TOKEN);

    return twilioClient.messages.create({
        body: fromUserName + ' (' + fromUserNumber + ')' + ' has invited you to join their Cartpool group! https://github.com/devinnicholson/slohacks',
        from: TWILIO_NUMBER,
        to: phoneNumber,
    }).then((response) => {
        console.log(response);
    });
});
