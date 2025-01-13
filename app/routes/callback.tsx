import { LoaderFunctionArgs } from "@remix-run/node";
import { authenticator } from "~/services/auth.server";

export async function loader({ request }: LoaderFunctionArgs) {
    let user = await authenticator.authenticate("microsoft", request);
    // now you have the user object with the data you returned in the verify function
    let session = await sessionStorage.getSession(request.headers.get("cookie"));
    session.set("user", user);
}