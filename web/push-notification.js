/**
 * async function
 * @returns token for messaging service
 */
 const askForPermissionToReceiveNotifications = async () => {
  try {
    const messaging = firebase.messaging();
    await messaging.requestPermission();
    const token = await messaging.getToken();
    console.log('client token for the messaging:\n', token);
    _logger('Got notification permission','alert-success',3500);
    return token;
  } catch (error) {
    console.error(error);
  }
}

/**
 * Obtain messaging class from Firebase
 */
const messaging = firebase.messaging();

/**
 * Service Worker explicit registration to explicitly define sw location at a path - Deprecated method (still works)
 */
// if ('serviceWorker' in navigator) {
//     navigator.serviceWorker.register('firebase-messaging-sw.js')
//         .then(function(registration) {
//             messaging.useServiceWorker(registration);
//             console.log('Registration successful, scope is:', registration.scope);
//             // ask for notification permission on app launch and if service worker is registered
//             askForPermissionToReceiveNotifications();
//         }).catch(function(err) {
//             console.log('Service worker registration failed, error:', err);
//         });
// }

/**
 * Service Worker explicit registration to explicitly define sw location at a path - New method 'getToken'
 */
if ('serviceWorker' in navigator) {
    navigator.serviceWorker.register('firebase-messaging-sw.js')
        .then(function(registration) {
            console.log('Registration successful, scope is:', registration.scope);
            messaging.getToken({
                // add your VPAID key here
                vapidKey: 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'})
                .then((currentToken) => {
                    if (currentToken) {
                        //TODO: Send the token to your server and update the UI if necessary
                        console.log(currentToken);
                    } else {
            // Show permission request UI
            console.log('No registration token available. Request permission to generate one.');
            askForPermissionToReceiveNotifications();
        }
    }).catch((err) => {
        console.log('An error occurred while retrieving token. ', err);
    });
}).catch(function(err) {
    console.log('Service worker registration failed, error:', err);
});
}

messaging.onMessage(function (payload) {
    console.log("Message received. ", payload);
    if(payload.data.notification) {
        // it's notification
        let shortNotif = JSON.parse(payload.data.notification);
        _logger(shortNotif.title+'\n'+shortNotif.body,'alert-info',5000);
    } else {
        // it's data
        _logger(payload.notification.title+'\n'+payload.notification.body,'alert-info',5000);
    }
});
messaging.onTokenRefresh(function () {
    messaging.getToken()
        .then(function (refreshedToken) {
            console.log('Token refreshed.');
            _logger(' Refreshed token is ' + refreshedToken,'alert-info',3000);
        }).catch(function (err) {
            _logger('Error: '+err,'alert-warning',5000);
            console.log('Unable to retrieve refreshed token ', err);
        });
});