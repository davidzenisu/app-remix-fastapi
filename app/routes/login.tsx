import { Form } from "@remix-run/react";
import type { ActionFunctionArgs } from "@remix-run/node";
import { authenticator } from "~/services/auth.server";

// First we create our UI with the form doing a POST and the inputs with the
// names we are going to use in the strategy
export default function Screen() {
    return (
        <Form method="post">
            <button>Sign In</button>
        </Form>
    );
}

// Second, we need to export an action function, here we will use the
// `authenticator.authenticate method`
export async function action({ request }: ActionFunctionArgs) {
    // we call the method with the name of the strategy we want to use and the
    // request object
    let user = await authenticator.authenticate("microsoft", request);

    let session = await sessionStorage.getSession(request.headers.get("cookie"));
    session.set("user", user);
}