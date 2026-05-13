# Privacy Policy for lakasir POS

**Last updated: May 13, 2026**

## Introduction

lakasir POS ("the App", "we", "our") is a point-of-sale application for small businesses. This Privacy Policy explains how the App handles information when you use it.

**Important:** lakasir POS connects to a server instance that **you own and control**. We do not operate, host, or have access to your server or the data stored on it. Your business data belongs exclusively to you.

---

## Information the App Processes

### Data Stored on Your Device

The App stores the following locally on your device using app-private storage (SharedPreferences):

| Data | Purpose |
|------|---------|
| Authentication token | Keeps you signed in |
| Server domain / URL | Connects to your lakasir server |
| Setup status | Remembers onboarding completion |
| User permissions | Manages feature access within the app |
| Offline authentication state | Enables offline mode usage |

This data never leaves your device except to authenticate with your own server.

### Data Sent to Your Server

The App communicates exclusively with the lakasir server instance **that you configure**. Data transmitted includes:

- **Account information**: email address and password for login
- **Profile data**: name, profile photo (if uploaded)
- **Business data**: products, inventory, categories, transactions, sales records, customer/member information
- **Images**: product photos uploaded via the image picker
- **Settings**: printer configurations, notification preferences

You control what data is stored on your server. We do not have access to it.

### Camera and Photos

The App may request access to your device camera or photo gallery when you:

- Add product images
- Update your profile photo

Images are sent to your lakasir server and are not shared with any third party by us.

### Bluetooth

The App may request Bluetooth access to connect to thermal printers for printing receipts. Bluetooth is used solely for printer communication.

### Push Notifications (Firebase Cloud Messaging)

The App uses **Firebase Cloud Messaging (FCM)** to deliver push notifications such as order updates and stock alerts. To enable this, a unique device token is sent to Google's Firebase service. This token does not identify you personally and is used solely for delivering notifications to your device.

Firebase is a service provided by Google LLC. You can review Google's privacy policy at [https://policies.google.com/privacy](https://policies.google.com/privacy).

---

## Data We Do NOT Collect

We do **not** collect, store, or have access to:

- Your business transaction data
- Your product inventory
- Your customer or member information
- Your sales reports or financial data
- Your server credentials or configuration
- Your location data
- Your device contacts or calendar

---

## Third-Party Services

The App integrates the following third-party services:

| Service | Purpose | Privacy Policy |
|---------|---------|---------------|
| Firebase (Google) | Push notifications | [policies.google.com/privacy](https://policies.google.com/privacy) |

No other third-party analytics, advertising, or tracking services are included.

---

## Data Retention and Deletion

- **Local data**: Uninstalling the App removes all locally stored data from your device.
- **Server data**: You control data retention on your lakasir server. Refer to your server's documentation for data management.
- **FCM token**: The device token registered with Firebase is automatically invalidated when you uninstall the App or clear app data.

---

## Children's Privacy

The App is not intended for use by children under the age of 13. We do not knowingly collect personal information from children.

---

## Security

The App communicates with your server over HTTPS (encrypted connection). Authentication tokens are stored securely in app-private storage. We recommend you secure your lakasir server with HTTPS and strong passwords.

---

## Your Rights

Since your data resides on your own server, you have full control over:
- Accessing your data through your server
- Correcting or updating your data
- Deleting your data from your server
- Exporting your data through your server's features

---

## Changes to This Policy

We may update this Privacy Policy from time to time. Changes will be posted within the App and on this page. Continued use of the App after changes constitutes acceptance.

---

## Contact

If you have questions about this Privacy Policy, contact us at:

- **Email**: support@lakasir.com
- **Website**: [https://lakasir.com](https://lakasir.com)
