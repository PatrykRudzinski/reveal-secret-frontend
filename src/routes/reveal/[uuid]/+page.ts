// since there's no dynamic data here, we can prerender
// it so that it gets served as a static asset in production

/** @type {import('./$types').PageLoad} */
export function load({ params }) {
	return { uuid: params.uuid };
}
