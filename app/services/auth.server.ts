// app/services/auth.server.ts
import { MicrosoftStrategy } from "remix-auth-microsoft";
import { Authenticator } from "remix-auth";

export let authenticator = new Authenticator<User>(); //User is a custom user types you can define as you want

interface User {
    id: string
}

let microsoftStrategy = new MicrosoftStrategy(
    {
        clientId: "90442738-405f-423f-987b-2e6da27c5531",
        clientSecret: "<YOUR_CLIENT_SECRET>",
        redirectURI: "http://localhost:5173/callback",
        tenantId: "41eb9a7a-3cb8-43f3-971b-4c6b9113c175", // optional - necessary for organization without multitenant (see below)
        scopes: ["e4484893-8dd3-4c43-9bf5-ff08ff7681b6/user_impersonation"], // optional
        prompt: "login", // optional
    },
    async ({ request, tokens }) => {
        // Here you can fetch the user from database or return a user object based on profile
        let accessToken = tokens.accessToken();
        let idToken = tokens.idToken();
        let profile = await MicrosoftStrategy.userProfile(accessToken);

        // The returned object is stored in the session storage you are using by the authenticator

        // If you're using cookieSessionStorage, be aware that cookies have a size limit of 4kb

        // Retrieve or create user using id received from userinfo endpoint
        // https://graph.microsoft.com/oidc/userinfo

        // DO NOT USE EMAIL ADDRESS TO IDENTIFY USERS
        // The email address received from Microsoft Entra ID is not validated and can be changed to anything from Azure Portal.
        // If you use the email address to identify users and allow signing in from any tenant (`tenantId` is not set)
        // it opens up a possibility of spoofing users!

        return { id: profile.id };
    }
);

authenticator.use(microsoftStrategy);