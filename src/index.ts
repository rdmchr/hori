console.log("Starting server...");
Bun.serve({
	port: 80,
	fetch(req, server) {
		const ip = server.requestIP(req)?.address;
		if (ip) {
			return new Response(ip, {
				headers: {
					"Content-Type": "text/plain",
				},
			});
		}
		return new Response("ERR", { status: 500 });
	},
});
