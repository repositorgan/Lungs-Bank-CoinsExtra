/**
 * CoinsExtra API Worker
 * ---------------------
 * This is the entry point for the Cloudflare Worker.
 * Wrangler loads this file based on `main` in wrangler.toml.
 */

export default {
  async fetch(request: Request, env: any): Promise<Response> {
    // Basic health check endpoint
    if (new URL(request.url).pathname === "/") {
      return new Response(
        JSON.stringify({
          status: "ok",
          service: "coinsextra-api",
          d1_bound: !!env.coinsextra_db
        }),
        { headers: { "Content-Type": "application/json" } }
      );
    }

    return new Response("Not Found", { status: 404 });
  }
};

